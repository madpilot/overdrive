require 'feedzirra'
require 'yaml'

class Feed
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
        @options[:logger].info "Fetching #{feed['url']}" if @options[:verbose]
        
        rss = Feedzirra::Feed.fetch_and_parse(feed['url'])
        @options[:logger].info "Processing #{feed['url']}" if @options[:verbose]
        @plugins.perform_filter(rss.entries)
        number_processed += 1
      rescue => e
        @options[:logger].error "Couldn't process #{e}"
      end
    end

    @options[:logger].info "Processed #{number_processed} out of #{@feeds.size - 1} feeds" if @options[:verbose]
    return number_processed
  end

  def check_downloads
    @options[:logger].info "Checking Download Status" if @options[:verbose]
    t = Transmission::Client.new(@options[:transmission_server], @options[:transmission_port])
    @plugins.download_complete(t.torrents)
  end
end
