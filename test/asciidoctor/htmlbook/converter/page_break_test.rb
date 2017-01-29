require 'test_helper'

class Asciidoctor::Htmlbook::Converter::PageBreakTest < ConverterTest
  def test_convert_page_break
    doc = <<~EOF
      <<<
    EOF

    html = <<~EOF
      <div data-type="page-break" />
    EOF

    assert_convert_body html, doc
  end
end
