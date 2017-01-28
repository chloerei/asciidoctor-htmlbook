require 'test_helper'

class Asciidoctor::Htmlbook::Converter::ParagraphTest < ConverterTest
  def test_convert_paragraph
    doc = <<~EOF
      Text
    EOF

    html = <<~EOF
      <p>Text</p>
    EOF

    assert_convert_equal html, doc
  end
end
