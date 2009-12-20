require 'optparse'

class Options
  def self.parse
    options = {
      :multiple => false
    }

    optparse = OptionParser.new do |opts|
      opts.banner = "Usage: torrent_rss [options]"

      options[:verbose] = false
      opts.on('-v', '--verbose', 'Be more verbose') do
        options[:verbose] = true
      end

      options[:dry_run] = false
      opts.on('-d', '--dry-run', "Don't actually queue torrents up") do |dry_run|
        options[:dry_run] = true
      end

      options[:interval] = 15
      opts.on('-i [n]', '--interval [n]', /\d+/, 'Number of minutes between checks (Default: 15)') do |interval|
        options[:interval] = interval.to_i
      end

      opts.on('-h', '--help', "You're looking at it") do
        puts opts
        exit(0)
      end

      options[:ontop] = false
      opts.on('-f', '--foreground', "Run in the foreground") do
        options[:ontop] = true
      end

      options[:transmission_server] = 'localhost'
      opts.on('-s [server]', '--transmission_server [server]', /.+/, 'Address of the transmission server (Default: localhost)') do |server|
        options[:transmission_server] = server
      end

      options[:transmission_port] = 9091
      opts.on('-p [port]', '--transmission_port', /\d+/, 'Port of the transmission server (Default: 9091)') do |port|
        options[:transmission_port] = port.to_i
      end
    end

    optparse.parse!
    options
  end
end
