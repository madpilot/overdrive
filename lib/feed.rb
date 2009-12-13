require 'rss'
require 'open-uri'
require 'yaml'

class Feed
  include OpenURI::OpenRead

  def initialize(options)
    @options = options
    @feeds = YAML.load_file(@options[:config_file])
  end

  def check
    check_feeds
    check_downloads
  end

  def check_feeds
    @plugins = DSL.new(@options)

    number_processed = 0
    @feeds['feeds'].each do |feed|
      begin
        puts "Fetching #{feed['url']}" if @options[:verbose]
        uri = URI.parse(feed['url'])
        rss = RSS::Parser.parse(uri.read)
        puts "Processing #{feed['url']}" if @options[:verbose]

        puts "Parsed" if @options[:verbose]
        @plugins.run(rss.items)
        number_processed += 1
      rescue => e
        puts e if @options[:verbose]
      end
    end

    return number_processed
  end

  def check_downloads
    puts "Checking Downloads..." if @options[:verbose]
  end
end
