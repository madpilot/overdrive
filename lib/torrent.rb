require 'open-uri'
require 'base64'

class Torrent
  include OpenURI::OpenRead

  def self.download(link, http_options = {}, options = {})
    uri = URI.parse(link)
    download_dir = http_options.delete(:download_dir)
    torrent = uri.read(http_options)
    t = Transmission::Client.new(options[:transmission_server], options[:transmission_port])
    t.add_torrent('metainfo' => Base64.encode64(torrent), 'download-dir' => download_dir)
  end
end
