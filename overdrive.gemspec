# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{overdrive}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Myles Eftos"]
  s.date = %q{2009-12-20}
  s.default_executable = %q{overdrive}
  s.description = %q{An RSS frontend for transmissions. It defines a basic DSL that allows you decide what you do once the files have been downloaded}
  s.email = %q{myles@madpilot.com.au}
  s.executables = ["overdrive"]
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    "README.markdown",
     "Rakefile",
     "VERSION",
     "bin/overdrive",
     "lib/dsl.rb",
     "lib/feed.rb",
     "lib/lexicon.rb",
     "lib/options.rb",
     "lib/torrent.rb",
     "test/fixtures/test.rss",
     "test/recipe.rb",
     "test/test_helper.rb",
     "test/unit/dsl.rb",
     "test/unit/feed.rb",
     "test/unit/lexicon.rb",
     "test/unit/torrent.rb"
  ]
  s.homepage = %q{http://github.com/madpilot/overdrive}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{An RSS frontend for transmission}
  s.test_files = [
    "test/test_helper.rb",
     "test/unit/feed.rb",
     "test/unit/lexicon.rb",
     "test/unit/dsl.rb",
     "test/unit/torrent.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<daemons>, [">= 0"])
      s.add_runtime_dependency(%q<transmission-client>, [">= 0"])
      s.add_runtime_dependency(%q<SyslogLogger>, [">= 0"])
    else
      s.add_dependency(%q<daemons>, [">= 0"])
      s.add_dependency(%q<transmission-client>, [">= 0"])
      s.add_dependency(%q<SyslogLogger>, [">= 0"])
    end
  else
    s.add_dependency(%q<daemons>, [">= 0"])
    s.add_dependency(%q<transmission-client>, [">= 0"])
    s.add_dependency(%q<SyslogLogger>, [">= 0"])
  end
end

