Overdrive
=========

Overdrive is a RSS frontend for the transmission bit torrent client. It has hooks to make downloading TV series
much easier, and allows recipes with callbacks to make filtering show much easier.

Installation
------------

Overdrive is a ruby gem that uses gemcutter. To install, simply do the following:

    sudo gem install gemcutter
    sudo gem tumble

then

    sudo gem install overdrive

This should install the overdrive binary in your path.

Usage
-----

To do anything useful, you need to setup a recipe. You can store the recipe (in Linux) at

    /etc/overdrive.rb
    /var/transmission/config/overdrive.rb
    $HOME/.overdrive/overdrive.rb

and you can add paths via the -c argument:

    overdrive -c /path/to/recipe.rb

A sample recipe might look like this:

    add_feed "http://www.mytorrents.com/torrents.rss"
    add_feed "http://www.myothertorrents.com/torrents.rss"

    add_title "24"
    add_title "30 Rock"
    add_title "Alias"

    filter do |item|
      parsed = parse_metadata(item)
      if parsed[:title] && parsed[:series] && parsed[:episode]
        title = parsed[:title].split(' ').map { |t| t[0..0].upcase + t[1..-1] }.join(' ')
      
        if titles.include?(title)
          target = "/videos/#{title}/Season #{parsed[:series].to_i.to_s}"
          download(item.url, :download_dir => target)
        end
      end
    end

You can get a full list of command line arguments by running

    overdrive -h

You can get a list of DSL commands on the wiki

[http://wiki.github.com/madpilot/overdrive]
