require 'test_helper'

class Asciidoctor::Htmlbook::ConverterTest < ::Minitest::Test
  include ConverterTestHelper

  def test_convert_with_template_dir
    doc = <<~EOF
      == Section

      Text
    EOF

    html = <<~EOF
      <section id='_section' data-type='chapter'>
        <h1>Section</h1>
        <p data-type='overwrite'>Text</p>
      </section>
    EOF

    assert_convert_body html, doc, template_dir: File.expand_path('../../../templates', __FILE__)
  end

  def test_convert_with_template_dirs
    doc = <<~EOF
      == Section

      Text
    EOF

    html = <<~EOF
      <section id='_section' data-type='chapter'>
        <h1>Section</h1>
        <p data-type='overwrite'>Text</p>
      </section>
    EOF

    assert_convert_body html, doc, template_dirs: [File.expand_path('../../../templates', __FILE__)]
  end

  def test_header_footer_options
    html = <<~EOF
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8" />
        </head>
        <body data-type="book">
          <p>Text</p>
        </body>
      </html>
    EOF
    assert_equal pretty_format(html), pretty_format(Asciidoctor.convert('Text', backend: 'htmlbook', header_footer: true))

    html = <<~EOF
      <p>Text</p>
    EOF
    assert_equal pretty_format(html), pretty_format(Asciidoctor.convert('Text', backend: 'htmlbook', header_footer: false))
  end
end
