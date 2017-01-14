require 'test_helper'

class Asciidoctor::Htmlbook::ConverterTest < Minitest::Test
  def setup
    @doc = Asciidoctor::Document.new nil, backend: 'htmlbook'
  end

  def test_convert_empty_document
    assert_equal <<~EOF, pretty_format(@doc.convert)
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset=\"utf-8\">
          <title></title>
        </head>
        <body data-type="book">
        </body>
      </html>
    EOF
  end

  def test_convert_section_sect1
    section = Asciidoctor::Section.new @doc
    section.sectname = 'sect1'
    section.title = 'Section Title'
    assert_equal <<~EOF, pretty_format(section.convert)
      <section data-type="sect1">
        <h1>Section Title</h1>
      </section>
    EOF
  end

  def test_convert_section_sect2
    section = Asciidoctor::Section.new @doc
    section.sectname = 'sect2'
    section.title = 'Section Title'
    section.level = 2
    assert_equal <<~EOF, pretty_format(section.convert)
      <section data-type="sect2">
        <h2>Section Title</h2>
      </section>
    EOF
  end

  def pretty_format(html)
    html.gsub(/^\s+\n/, '')
  end
end
