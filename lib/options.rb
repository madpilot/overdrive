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

      options[:config_file] = File.join(File.dirname(File.expand_path(__FILE__)), '..', 'config', 'settings.yaml')
      opts.on('-c [config]', '--config [config]', /.+/, 'Path to the config YAML file') do |config_file|
        options[:config_file] = config_file
      end

      options[:interval] = 15
      opts.on('-i [n]', '--interval [n]', /\d+/, 'Number of minutes between checks') do |interval|
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
      opts.on('-s [server]', '--transmission_server [server]', /.+/, 'Address of the transmission server') do |server|
        options[:transmission_server] = server
      end

      options[:transmission_port] = 9091
      opts.on('-p', '--transmission_port', /\d+/, 'Posrt of the transmission server') do |port|
        options[:transmission_port] = port.to_i
      end
    end

    optparse.parse!
    options
  end
end
