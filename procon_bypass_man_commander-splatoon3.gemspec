
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "procon_bypass_man_commander/splatoon3/version"

Gem::Specification.new do |spec|
  spec.name          = "procon_bypass_man_commander-splatoon3"
  spec.version       = ProconBypassManCommander::Splatoon3::VERSION
  spec.authors       = ["jiikko"]
  spec.email         = ["n905i.1214@gmail.com"]

  spec.summary       = %q{a gem for splatoon3}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/splaplapla/procon_bypass_man_commander-splatoon3"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ropencv"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
