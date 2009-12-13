require 'transmission-client'

class DSL
  attr_accessor :titles

  def initialize(options)
    @options = { :filter => File.join(File.dirname(File.expand_path(__FILE__)), '..', 'filter.rb') }.merge(options)

    @titles = []
    # Read in the filter file
    File.open(@options[:filter], 'r') do |fh|
      eval <<-END
        def run(items)
          @items = items
          #{fh.read}
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

  def log(str)
    puts str if @options[:verbose]
  end

  def download(link)
    Torrent.download(link) 
  end

  def filter &block
    @items.each { |item| yield(item) }
  end

  def after &block
    @items.each { |item| yield(item) }
  end
end
