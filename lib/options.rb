require 'optparse'

class Options
  def self.parse
    options = {
      :multiple => false
    }

    optparse = OptionParser.new do |opts|
      opts.banner = "Usage: #{opts.program_name} [options]"

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
        exit(-1)
      end

      options[:ontop] = false
      opts.on('-f', '--foreground', "Run in the foreground") do
        options[:ontop] = true
      end

      options[:filter_paths] = [ File.join(File.dirname(__FILE__), '..', 'recipe.rb'), File.join('etc', 'overdrive.rb'), File.join('var' , 'transmission' , 'config' , 'overdrive.rb') ]
      options[:filter_paths] << File.join(ENV['HOME'], '.overdrive', 'overdrive.rb') if ENV['HOME']
      options[:filter_paths] += ENV['OVERDRIVE_RECIPES'].split(':') if ENV['OVERDRIVE_RECIPES']
      
      opts.on('-r [recipe]', '--recipes [recipe]', /.+/, 'Reads in additional recipes') do |recipes|
        options[:filter_paths] << recipes
      end

      options[:transmission_server] = 'localhost'
      opts.on('-s [server]', '--transmission_server [server]', /.+/, 'Address of the transmission server (Default: localhost)') do |server|
        options[:transmission_server] = server
      end

      options[:transmission_port] = 9091
      opts.on('-p [port]', '--transmission_port', /\d+/, 'Port of the transmission server (Default: 9091)') do |port|
        options[:transmission_port] = port.to_i
      end

      opts.on('-v', '--version') do
        File.open(File.join(File.dirname(__FILE__), '..', 'VERSION')) do |fh|
          puts fh.read
        end
        exit(0)
      end
    end

    begin
      optparse.parse!
      options
    rescue OptionParser::InvalidOption => e
      puts optparse
      exit(-1)
    end
  end
end
