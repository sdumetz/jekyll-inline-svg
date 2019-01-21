# coding: utf-8

Gem::Specification.new do |spec|
  spec.name        = "jekyll-inline-svg"
  spec.summary     = "A SVG Inliner for Jekyll"
  spec.description = <<-EOF
  A Liquid tag to inline and optimize SVG images in your HTML
  Supports custom DOM Attributes parameters and variables interpretation.
  EOF
  spec.version     = "1.1.3"
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

  spec.add_development_dependency "rspec", "~> 3.6"
  spec.add_development_dependency "rake", "~>12.0"
  spec.add_development_dependency "bundler", "~> 1.15"
end
