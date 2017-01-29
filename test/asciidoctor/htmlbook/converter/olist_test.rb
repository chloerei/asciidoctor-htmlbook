require 'test_helper'

class Asciidoctor::Htmlbook::Converter::OlistTest < ConverterTest
  def test_convert_olist
    doc = <<~EOF
      . listitem
      . listitem
      . listitem
    EOF

    html = <<~EOF
      <ol>
        <li>
          <p>listitem</p>
        </li>
        <li>
          <p>listitem</p>
        </li>
        <li>
          <p>listitem</p>
        </li>
      </ol>
    EOF

    assert_convert_body html, doc
  end

  def test_convert_olist_nested
    doc = <<~EOF
      . listitem
      .. listitem
      . listitem
    EOF

    html = <<~EOF
      <ol>
        <li>
          <p>listitem</p>
          <ol>
            <li>
              <p>listitem</p>
            </li>
          </ol>
        </li>
        <li>
          <p>listitem</p>
        </li>
      </ol>
    EOF

    assert_convert_body html, doc
  end

end
