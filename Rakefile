begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "overdrive"
    s.executables = "overdrive"
    s.summary = "An RSS frontend for transmission"
    s.email = "myles@madpilot.com.au"
    s.homepage = "http://github.com/madpilot/overdrive"
    s.description = "An RSS frontend for transmissions. It defines a basic DSL that allows you decide what you do once the files have been downloaded"
    s.authors = ["Myles Eftos"]
    s.files =  FileList["[A-Z]*", "{bin,generators,lib,test}/**/*", 'lib/jeweler/templates/.gitignore']
    
    s.add_dependency 'daemons'
    s.add_dependency 'transmission-client'
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
