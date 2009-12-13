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

      options[:config_file] = File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'feeds.yaml'))
      opts.on('-c', '--config', 'Path to the config YAML file') do |config_file|
        options[:config_file] = config_file
      end

      options[:interval] = 15
      opts.on('-i', '--interval', 'Number of minutes between checks') do |interval|
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
    end

    optparse.parse!

    options
  end
end
