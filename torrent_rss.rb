#!/usr/bin/env ruby
$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'daemons'
require 'options'
require 'feeds'
require 'plugins'

options = Options.parse

Daemons.call(options) do
  @last_run = nil
  @feed = Feeds.new(options)
  @filter_plugins = Plugins.load_filters(options)
  @post_processing_plugins = Plugins.load_post_processors(options)

  loop {
    if @last_run == nil || @last_run >= DateTime.now + (options[:interval] * 60)
      @feed.check
      @last_run = DateTime.now
    end
    sleep(1)
  }
end
