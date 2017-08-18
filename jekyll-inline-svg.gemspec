# coding: utf-8

Gem::Specification.new do |spec|
  spec.name        = "jekyll-inline-svg"
  spec.summary     = "A Liquid tag for Jekyll to inline SVG images in your HTML"
  spec.version     = "0.0.1"
  spec.authors     = ["Sebastien DUMETZ"]
  spec.email       = "s.dumetz@holusion.com"
  spec.homepage    = "https://github.com/sdumetz/jekyll-inline-svg"
  spec.licenses    = ["GPL-3.0"]

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r!^bin/!) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r!^(test|spec|features)/!)
  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll", "~> 3.3"
  spec.add_dependency 'svg_optimizer', "0.1.0"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "bundler"
end
