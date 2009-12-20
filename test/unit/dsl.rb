require 'test_helper'

class DslTest < Test::Unit::TestCase
  include TestHelper
  
  context '' do
    setup do
      @logger = Logger.new(File.open('/dev/null', 'w'))
      
      @options = { 
        :logger => @logger, 
        :filter_paths => filter_paths 
      }
      
      @feed = Feed.new(@options)
      @dsl = DSL.new(@options)
      
      FakeWeb.register_uri(:get, "http://www.mytorrentsite.com/feed.rss", :body => bitme_rss)
    end

    context 'setup' do
      should 'prime the DSL on initialize' do
        assert @dsl.instance_variable_get(:@primed)
      end
    end

    context 'loader' do
      should 'define run_dsl dynamically' do
        assert @dsl.respond_to?(:run_dsl) 
      end

      should 'map perform_filter to run_dsl' do
        @items = []
        @dsl.expects(:run_dsl).with(@items, :filter)
        @dsl.perform_filter(@items)
      end

      should 'map download_complete to run_dsl' do
        @items = []
        @dsl.expects(:run_dsl).with(@items, :torrent)
        @dsl.download_complete(@items)
      end
    end

    context 'add_title' do
      should 'register a title if @primed is false' do
        @dsl.instance_variable_set(:@primed, false)
        assert 2, @dsl.instance_variable_get(:@titles).size
        @dsl.add_title('Test Title 3')
        assert 3, @dsl.instance_variable_get(:@titles).size
      end

      should 'not register a title if @primed is true' do
        @dsl.instance_variable_set(:@primed, true)
        assert 2, @dsl.instance_variable_get(:@titles).size
        @dsl.add_title('Test Title 3')
        assert 2, @dsl.instance_variable_get(:@titles).size
      end
    end

    context 'add_feed' do
      should 'register a feed if @primed is false' do
        @dsl.instance_variable_set(:@primed, false)
        assert 2, @dsl.instance_variable_get(:@feeds).size
        @dsl.add_title('http://www.feedsfeedsfeeds.com/feed.rss')
        assert 3, @dsl.instance_variable_get(:@feeds).size
      end

      should 'not register a title if @primed is true' do
        @dsl.instance_variable_set(:@primed, true)
        assert 2, @dsl.instance_variable_get(:@feeds).size
        @dsl.add_title('http://www.feedsfeedsfeeds.com/feed.rss')
        assert 2, @dsl.instance_variable_get(:@feeds).size
      end
    end

    context 'parse_metadata' do
      should 'call Lexicon::parse' do
        item = mock
        ret = mock
        Lexicon.expects(:parse).with(item).returns(ret)
        assert_equal ret, @dsl.parse_metadata(item)
      end
    end

    context 'download' do
      should 'call Torrent::download' do
        link = mock
        options = mock
        @dsl.stubs(:options).returns({})
        Torrent.expects(:download).with(link, options, {})
        @dsl.download(link, options)
      end
    end

    context 'log' do
      should 'logs' do
        logger = mock
        options = {:logger => logger}
        @dsl.stubs(:options).returns(options)
        assert_equal logger, @dsl.log
      end
    end
  end
end
