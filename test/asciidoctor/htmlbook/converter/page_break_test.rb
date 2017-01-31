require 'test_helper'

class Asciidoctor::Htmlbook::Converter::PageBreakTest < Minitest::Test
  include ConverterTestHelper

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
