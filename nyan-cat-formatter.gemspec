$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "nyan-cat-formatter"
  s.version     = "0.0.3"
  s.authors     = ["Matt Sears"]
  s.email       = ["matt@mattsears.com"]
  s.homepage    = "http://mtts.rs/nyancat"
  s.summary     = %q{Nyan Cat inspired RSpec formatter! }
  s.description = %q{Nyan Cat inspired RSpec formatter! }

  s.rubyforge_project = "nyan-cat-formatter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
end
