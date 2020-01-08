# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asciidoctor/htmlbook/version'

Gem::Specification.new do |spec|
  spec.name          = "asciidoctor-htmlbook"
  spec.version       = Asciidoctor::Htmlbook::VERSION
  spec.authors       = ["Rei"]
  spec.email         = ["chloerei@gmail.com"]

  spec.summary       = %q{Asciidoctor HTMLBook is an Asciidoctor backend for converting AsciiDoc documents to HTMLBook documents.}
  spec.description   = %q{Asciidoctor HTMLBook is an Asciidoctor backend for converting AsciiDoc documents to HTMLBook documents.}
  spec.homepage      = "https://github.com/chloerei/asciidoctor-htmlbook"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "asciidoctor", "~> 2.0"
  spec.add_runtime_dependency "liquid", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
