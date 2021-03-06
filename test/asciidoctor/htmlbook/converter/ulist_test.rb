require 'test_helper'

class Asciidoctor::Htmlbook::Converter::UlistTest < Minitest::Test
  include ConverterTestHelper

  def test_convert_ulist
    doc = <<~EOF
      * listitem
      * listitem
      * listitem
    EOF

    html = <<~EOF
      <ul>
        <li>
          <p>listitem</p>
        </li>
        <li>
          <p>listitem</p>
        </li>
        <li>
          <p>listitem</p>
        </li>
      </ul>
    EOF

    assert_convert_body html, doc
  end

  def test_convert_ulist_nested
    doc = <<~EOF
      * listitem
      ** listitem
      * listitem
    EOF

    html = <<~EOF
      <ul>
        <li>
          <p>listitem</p>
          <ul>
            <li>
              <p>listitem</p>
            </li>
          </ul>
        </li>
        <li>
          <p>listitem</p>
        </li>
      </ul>
    EOF

    assert_convert_body html, doc
  end
end
