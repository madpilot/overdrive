require 'transmission-client'

class DSL
  attr_accessor :titles

  def initialize(options)
    @options = { :filter => File.join(File.dirname(File.expand_path(__FILE__)), '..', 'filter.rb') }.merge(options)

    @titles = []
    # Read in the filter file
    File.open(@options[:filter], 'r') do |fh|
      contents = fh.read
      eval <<-END
        def perform_filter(items)
          @items = items
          #{contents}
         end

         def download_complete(torrents)
          @torrents = torrents
          #{contents}
         end
       END
    end
  end
 
  def add_title(title)
    @titles << title
  end

  def parse_metadata(item)
    Lexicon.parse(item) 
  end

  def log
    @options[:logger]
  end

  def options
    @options
  end

  def download(link, options = {})
    Torrent.download(link, options) 
  end

  def filter &block
    @items.each { |item| yield(item) }
  end

  def after &block
    @torrents.each { |torrent| yield(torrent) }
  end
end
