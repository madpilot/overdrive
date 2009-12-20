require 'test_helper'
require 'logger'

class FeedTest < Test::Unit::TestCase
  include TestHelper
  
  context '' do
    setup do
      @feed_urls = [ 'http://www.mytorrentsite.com/feed.rss' ]
      DSL.any_instance.stubs(:feeds).returns(@feed_urls)

      @logger = Logger.new(File.open('/dev/null', 'w'))
      @feed = Feed.new({ :on_top => true, :logger => @logger })
      feed = Feedzirra::Feed.parse(bitme_rss)
      feed_ret = {}
      @feed_urls.each { |f| feed_ret[f] = feed }
      Feedzirra::Feed.stubs(:fetch_and_parse).returns(feed_ret) 
    end

    context 'check' do
      setup do
        @transmission_client = mock
        Transmission::Client.stubs(:new).returns(@transmission_client)
        @transmission_client.stubs(:torrents).returns([]) 
      end
      
      should 'call check_feed' do
        DSL.any_instance.expects(:download_complete).with([])
        @feed.expects(:check_feeds)
        @feed.check
      end
    end

    context 'check_feed' do
      should 'download each RSS feed' do
        DSL.any_instance.expects(:perform_filter).times(@feed_urls.size)
        @logger.expects(:error).never
        assert_equal @feed_urls.size, @feed.check_feeds
      end
    end

    context 'update_feed' do
      should 'do nothing if there is no updated entries' do
        feed = Feedzirra::Feed.parse(bitme_rss)
        Feedzirra::Feed.stubs(:update).returns(feed)
        Feedzirra::Feed.stubs(:updated?).returns(false)
        Feedzirra::Feed.stubs(:new_entries).returns([])
        
        DSL.any_instance.expects(:perform_filter).never
        @logger.expects(:error).never
        assert_equal 0, @feed.update_feeds
      end
    end
  end
end
