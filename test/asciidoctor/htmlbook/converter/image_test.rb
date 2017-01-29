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

    assert_convert_body html, doc
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

    assert_convert_body html, doc
  end

  def test_convert_image_with_size_and_link
    doc = <<~EOF
      image::http://example.com/logo.png[logo, 400, 300, link="http://example.com/"]
    EOF

    html = <<~EOF
      <figure>
        <a href="http://example.com/">
          <img src="http://example.com/logo.png" alt="logo" width="400" height="300" />
        </a>
      </figure>
    EOF

    assert_convert_body html, doc
  end
end
