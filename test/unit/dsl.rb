require 'test_helper'

class DslTest < Test::Unit::TestCase
  include TestHelper
  
  context '' do
    setup do
      yaml = File.join(File.dirname(File.expand_path(__FILE__)), '..', 'config', 'settings.yaml')
      @config = YAML.load_file(yaml)
      @feed = Feed.new({ :config_file => yaml })
      FakeWeb.register_uri(:get, "http://www.mytorrentsite.com/feed.rss", :body => bitme_rss)
      @dsl = DSL.new(:filter => File.join(File.dirname(File.expand_path(__FILE__)), '..', 'filter.rb'))
   end

    context 'filters' do
      should 'define perform_filter dynamically' do
        assert @dsl.respond_to?(:perform_filter) 
      end

      should 'define download_complete dynamically' do
        assert @dsl.respond_to?(:download_complete)
      end
    end

    context 'add_title' do
      should 'register a title' do
        assert 2, @dsl.instance_variable_get(:@titles).size
        @dsl.add_title('Test Title 3')
        assert 3, @dsl.instance_variable_get(:@titles).size
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

    context 'log' do
      should 'print out the string if the verbose option is true'
    end
  end
end
