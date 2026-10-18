# AGENTS.md

## Development environment

- Ruby commands (Bundler, Rake, the test suite, `exe/asciidoctor-htmlbook`) must
run inside the devcontainer, not on the host Ruby.

## Release

1. Bump `Asciidoctor::Htmlbook::VERSION` in `lib/asciidoctor/htmlbook/version.rb`
   and commit. Skip `CHANGELOG.adoc`; release notes replace it.
2. Tag and push: `git tag v0.0.7 && git push origin master v0.0.7`.
3. Create a draft GitHub Release for the tag.
4. The maintainer reviews the draft, then publishes it.
