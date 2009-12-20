require 'feedzirra'
require 'yaml'

class Feed
  def initialize(options)
    @options = options
    @dsl = DSL.new(@options)
  end

  def check
    @results ? update_feeds : check_feeds
    check_downloads
  end

  def check_feeds
    number_processed = 0
    feeds = @dsl.feeds
    feed_size = feeds.size
    
    begin
      @options[:logger].info "Fetching #{feed_size} feed#{feed_size == 1 ? "" : "s"}" if @options[:verbose]
      
      @results = Feedzirra::Feed.fetch_and_parse(feeds)
      
      @options[:logger].info "Processing #{feed_size} feed#{feed_size == 1 ? "" : "s"}" if @options[:verbose]
      
      @results.each do |url, rss|
        if rss.is_a?(Fixnum)
          @options[:logger].error "Couldn't download #{url}"
        else
          @dsl.perform_filter(rss.entries)
          number_processed += 1
        end
      end
    rescue => e
      @options[:logger].error "#{e}"
    end

    @options[:logger].info "Processed #{number_processed} out of #{feed_size} feed#{feed_size == 1 ? "" : "s"}" if @options[:verbose]
    return number_processed
  end

  def update_feeds
    number_processed = 0
    number_skipped = 0
    feeds = @results
    feed_size = feeds.size

    begin
      @options[:logger].info "Fetching #{feed_size} feed#{feed_size ? "" : "s"}" if @options[:verbose]
      
      results = Feedzirra::Feed.update(feeds.values)
      @options[:logger].info "Processing #{feed_size} feed#{feed_size ? "" : "s"}" if @options[:verbose]
      
      if results.updated?
        @dsl.perform_filter(results.new_entries)
      else
        number_skipped += 1
      end
      number_processed += 1
    rescue => e
      @options[:logger].error "#{e}"
    end

    @options[:logger].info "Processed #{number_processed} out of #{feed_size} feed#{feed_size ? "" : "s"} (#{number_skipped} skipped)" if @options[:verbose]
    return number_processed   
  end

  def check_downloads
    return if @options[:dry_run]
    @options[:logger].info "Checking Download Status" if @options[:verbose]
    t = Transmission::Client.new(@options[:transmission_server], @options[:transmission_port])
    @dsl.download_complete(t.torrents)
  end
end
