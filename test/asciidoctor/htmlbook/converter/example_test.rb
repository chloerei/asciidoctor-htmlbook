require 'test_helper'

class Asciidoctor::Htmlbook::Converter::ExampleTest < ConverterTest
  def test_convert_example
    doc = <<~EOF
      ====
      Example
      ====
    EOF

    html = <<~EOF
      <div data-type="example">
        <p>Example</p>
      </div>
    EOF

    assert_convert_equal html, doc
  end

  def test_convert_example_with_title
    doc = <<~EOF
      .Example Title
      ====
      Example
      ====
    EOF

    html = <<~EOF
      <div data-type="example">
        <h5>Example Title</h5>
        <p>Example</p>
      </div>
    EOF

    assert_convert_equal html, doc
  end
end
