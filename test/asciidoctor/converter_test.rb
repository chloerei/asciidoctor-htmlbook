require 'test_helper'
require 'rexml/document'

class Asciidoctor::Htmlbook::ConverterTest < Minitest::Test
  def setup
    @doc = Asciidoctor::Document.new nil, backend: 'htmlbook'
  end

  def test_convert_empty_document
    assert_equal_xhtml <<~EOF, @doc.convert
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset=\"utf-8\" />
          <title></title>
        </head>
        <body data-type="book">
        </body>
      </html>
    EOF
  end

  def test_convert_section_part
    section = Asciidoctor::Section.new @doc
    section.sectname = 'sect0'
    section.title = 'Part Title'
    assert_equal_xhtml <<~EOF, section.convert
      <section data-type="part">
        <h1>Part Title</h1>
      </section>
    EOF
  end

  def test_convert_section_sect1
    section = Asciidoctor::Section.new @doc
    section.sectname = 'sect1'
    section.title = 'Chapter Title'
    assert_equal_xhtml <<~EOF, section.convert
      <section data-type="chapter">
        <h1>Chapter Title</h1>
      </section>
    EOF
  end

  def test_convert_section_sect2
    section = Asciidoctor::Section.new @doc
    (1..5).each do |level|
      section.sectname = "sect#{level + 1}"
      section.title = 'Section Title'
      assert_equal_xhtml <<~EOF, section.convert
        <section data-type="sect#{level}">
          <h#{level}>Section Title</h#{level}>
        </section>
      EOF
    end
  end

  def test_convert_section_preface
    section = Asciidoctor::Section.new @doc
    section.sectname = 'preface'
    section.title = 'Preface Title'
    assert_equal_xhtml <<~EOF, section.convert
      <section data-type="preface">
        <h1>Preface Title</h1>
      </section>
    EOF
  end

  def assert_equal_xhtml(except, actual)
    assert_equal pretty_format(except), pretty_format(actual)
  end

  def pretty_format(html)
    out = ""
    REXML::Document.new(html).write(out, 2)
    out.gsub(/^\s*\n/, '')
  end
end
