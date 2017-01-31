require 'test_helper'

class Asciidoctor::Htmlbook::Converter::PassTest < Minitest::Test
  include ConverterTestHelper

  def test_convert_pass
    doc = <<~EOF
      ++++
      Pass
      ++++
    EOF

    html = <<~EOF
      Pass
    EOF

    assert_convert_body html, doc
  end
end
