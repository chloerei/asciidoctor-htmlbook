require 'test_helper'

class Asciidoctor::Htmlbook::Converter::InlineImageTest < ConverterTest
  def test_convert_inline_image
    doc = <<~EOF
      image:http://example.com/logo.png[]
    EOF

    html = <<~EOF
      <p><img src="http://example.com/logo.png" alt="logo" /></p>
    EOF

    assert_convert_body html, doc
  end

  def test_convert_inline_image_with_title
    doc = <<~EOF
      image:http://example.com/logo.png[alt, title="title"]
    EOF

    html = <<~EOF
      <p><img src="http://example.com/logo.png" alt="alt" title="title" /></p>
    EOF

    assert_convert_body html, doc
  end
end