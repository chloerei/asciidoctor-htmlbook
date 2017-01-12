require 'test_helper'

class Asciidoctor::Htmlbook::ConverterTest < Minitest::Test
  def test_convert_empty_document
    adoc = <<~EOF
      text
    EOF

    html = <<~EOF
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset=\"utf-8\">
          <title></title>
        </head>
        <body data-type="book">
          <p>text</p>

        </body>
      </html>
    EOF

    assert_equal html, Asciidoctor.convert(adoc, backend: 'htmlbook')
  end
end
