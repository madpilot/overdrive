require 'test_helper'

class FeedTest < Test::Unit::TestCase
  include TestHelper
  
  context '' do
    setup do
      @dsl = mock()
      DSL.stubs(:new).returns(@dsl)

      yaml = File.join(File.dirname(File.expand_path(__FILE__)), '..', 'feed.yaml')
      @config = YAML.load_file(yaml)
      @feed = Feed.new({ :config_file => yaml })
      FakeWeb.register_uri(:get, "http://www.mytorrentsite.com/feed.rss", :body => bitme_rss)
    end

    context 'check' do
      should 'call check_feed' do
        @feed.expects(:check_feeds)
        @feed.check
      end
    end

    context 'check_feed' do
      should 'download each RSS feed in the config file' do
        @dsl.expects(:run).times(@config['feeds'].size)
        assert @config['feeds'].size, @feed.check_feeds
      end
    end
  end
end
