require 'test_helper'

class Asciidoctor::Htmlbook::Converter::InlineFootnoteTest < Minitest::Test
  include ConverterTestHelper

  def test_convert_footnote
    doc = <<~EOF
      Content.footnote:[Footnote content.]
    EOF

    html = <<~EOF
      <p>Content.<span data-type="footnote">Footnote content.</span></p>
    EOF

    assert_convert_body html, doc
  end

  def test_convert_footnoteref
    doc = <<~EOF
      Content one.footnoteref:[refid, Footnote content.]

      Content two.footnoteref:[refid]
    EOF

    html = <<~EOF
      <p>Content one.<span data-type="footnote">Footnote content.</span></p>

      <p>Content two.<span data-type="footnote">Footnote content.</span></p>
    EOF

    assert_convert_body html, doc
  end
end
