$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "nyan-cat-formatter"
  s.version     = "0.10.1"
  s.authors     = ["Matt Sears"]
  s.email       = ["matt@mattsears.com"]
  s.homepage    = "https://github.com/mattsears/nyan-cat-formatter"
  s.summary     = %q{Nyan Cat inspired RSpec formatter!}
  s.description = s.summary

  s.rubyforge_project = "nyan-cat-formatter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rspec", ">= 2.14.2", ">= 2.99", "< 4"

  s.add_development_dependency "rake"
end
