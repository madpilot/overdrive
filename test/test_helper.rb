$:.unshift File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib')

require 'rubygems'
require 'daemons'
require 'options'
require 'feed'
require 'torrent'
require 'lexicon'
require 'dsl'

require 'redgreen'
require 'test/unit'
require 'mocha'
require 'shoulda'
require 'fakefs/safe'
require 'fakeweb'

module TestHelper
  def bitme_rss
    File.open(File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures', 'test.rss')) do |rss|
      rss.read  
    end
  end
end
