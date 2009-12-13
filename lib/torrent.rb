require 'open-uri'

class Torrent
  include OpenURI::OpenRead

  def self.download(link, options = {})
    uri = URI.parse(link)
    torrent = uri.read(options)
  end
end
