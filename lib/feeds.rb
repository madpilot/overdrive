require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
require 'yaml'

class Feeds
  include OpenURI::OpenRead

  def initialize(options)
    @options = options
    @feeds = YAML.load_file(@options[:config_file])
  end
  
  def check
    @feeds['feeds'].each do |feed|
      begin
        puts "Fetching #{feed['url']}" if @options[:verbose]
        rss = read(feed['url'])
        puts rss 
      rescue => e
        puts e if @options[:verbose]
      end
    end
  end
end
