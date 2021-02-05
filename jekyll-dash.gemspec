# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "jekyll-dash"
  spec.version       = "1.3.4"
  spec.authors       = ["Burak ERGÜL"]
  spec.email         = ["burakcan41@gmail.com"]

  spec.summary       = "Personel Blog"
  spec.homepage      = "https://ergulburak.github.io/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_plugins|_sass|LICENSE|README)!i) }

  spec.add_runtime_dependency "jekyll", "~> 3.5"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.9"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.1"
  spec.add_runtime_dependency "jekyll-paginate"

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 12.0"
end
