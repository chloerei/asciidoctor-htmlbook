require 'test_helper'

class Asciidoctor::Htmlbook::Converter::ThematicBreakTest < Minitest::Test
  include ConverterTestHelper

  def test_convert_thematic_break
    doc = <<~EOF
      '''
    EOF

    html = <<~EOF
      <hr />
    EOF

    assert_convert_body html, doc
  end
end
