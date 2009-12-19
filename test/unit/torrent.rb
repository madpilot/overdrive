require 'test_helper'
require 'base64'

class DslTest < Test::Unit::TestCase
  include TestHelper

  context '' do
    setup do
      @fake_torrent_file = "This really isn't a torrent file"
      @transmission_client = mock
      Transmission::Client.stubs(:new).returns(@transmission_client)
      FakeWeb.register_uri(:get, "http://www.mytorrentsite.com/tv_show.torrent", :body => @fake_torrent_file)
    end

    context 'download' do
      should 'pass a base64 encoded version of the supplied data and the download directory' do
        @transmission_client.stubs(:add_torrent).with('metainfo' => Base64.encode64(@fake_torrent_file), 'download-dir' => '/Downloads')
        Torrent.download('http://www.mytorrentsite.com/tv_show.torrent', :download_dir => '/Downloads')
      end
    end
  end
end
