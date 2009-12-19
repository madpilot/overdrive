require 'test_helper'
require 'logger'

class FeedTest < Test::Unit::TestCase
  include TestHelper
  
  context '' do
    setup do
      yaml = File.join(File.dirname(File.expand_path(__FILE__)), '..', 'config', 'settings.yaml')
      @config = YAML.load_file(yaml)
      @config[:on_top] = true
      @logger = Logger.new(File.open('/dev/null', 'w'))
      @feed = Feed.new({ :config_file => yaml, :logger => @logger })
      feed = Feedzirra::Feed.parse(bitme_rss)
      Feedzirra::Feed.stubs(:fetch_and_parse).returns(feed) 
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
      should 'download each RSS feed in the config file' do
        DSL.any_instance.expects(:perform_filter).times(@config['feeds'].size)
        @logger.expects(:error).never
        assert @config['feeds'].size, @feed.check_feeds
      end
    end
  end
end
