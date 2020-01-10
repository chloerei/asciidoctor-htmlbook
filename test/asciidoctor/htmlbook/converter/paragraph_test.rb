require 'test_helper'

class Asciidoctor::Htmlbook::Converter::ParagraphTest < Minitest::Test
  include ConverterTestHelper

  def test_convert_paragraph
    doc = <<~EOF
      Text
    EOF

    html = <<~EOF
      <p>Text</p>
    EOF

    assert_convert_body html, doc
  end

  def test_convert_with_id
    doc = <<~EOF
      [[text]]
      Text
    EOF

    html = <<~EOF
      <p id="text">Text</p>
    EOF

    assert_convert_body html, doc
  end
end
