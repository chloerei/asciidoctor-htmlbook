require 'test_helper'

class Asciidoctor::Htmlbook::Converter::ImageTest < ConverterTest
  def test_convert_image
    doc = <<~EOF
      image::http://example.com/logo.png[]
    EOF

    html = <<~EOF
      <figure>
        <img src="http://example.com/logo.png" alt="logo" />
      </figure>
    EOF

    assert_convert_equal html, doc
  end

  def test_convert_image_with_title
    doc = <<~EOF
      .Image Title
      image::http://example.com/logo.png[]
    EOF

    html = <<~EOF
      <figure>
        <img src="http://example.com/logo.png" alt="logo" />
        <figcaption>Image Title</figcaption>
      </figure>
    EOF

    assert_convert_equal html, doc
  end
end
