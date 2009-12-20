require 'transmission-client'

class DSL
  attr_accessor :titles

  def initialize(options)
    @options = { :filter => File.join(File.dirname(File.expand_path(__FILE__)), '..', 'filter.rb') }.merge(options)
    @items, @torrents, @feeds, @titles = [], [], [], []
    
    File.open(@options[:filter], 'r') do |fh|
      contents = fh.read
      eval <<-END
        def run_dsl(obj = nil, type = nil)
          @items = []
          @torrents = []

          case(type)
          when :filter
            @items = obj
          when :torrent
            @torrents = obj
          end
          
          #{contents}
        end
       END
    end

    # Prime the DSL
    @primed = false
    run_dsl
    @primed = true
  end

  def perform_filter(items)
    run_dsl(items, :filter)
  end

  def download_complete(torrents)
    run_dsl(torrents, :torrent)
  end

  def add_feed(feed)
    @feeds << feed unless @primed
  end

  def feeds
    @feeds
  end

  def add_title(title)
    @titles << title unless @primed
  end

  def parse_metadata(item)
    Lexicon.parse(item) 
  end

  def log
    options[:logger]
  end

  def options
    @options
  end

  def download(link, options = {})
    Torrent.download(link, options, self.options) 
  end

  def filter &block
    @items.each { |item| yield(item) }
  end

  def after &block
    @torrents.each { |torrent| yield(torrent) }
  end
end
