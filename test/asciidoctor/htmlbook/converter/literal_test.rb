require 'test_helper'

class Asciidoctor::Htmlbook::Converter::LiteralTest < ConverterTest
  def test_convert_literal
    doc = <<~EOF
      ....
      Text
      ....
    EOF

    html = <<~EOF
      <pre>Text</pre>
    EOF

    assert_convert_body html, doc
  end
end
