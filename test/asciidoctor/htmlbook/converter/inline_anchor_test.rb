require 'test_helper'

class Asciidoctor::Htmlbook::Converter::InlineAnchorTest < Minitest::Test
  include ConverterTestHelper

  def test_convert_inline_anchor_xref_with_text
    doc = <<~EOF
      <<target, text>>
    EOF

    html = <<~EOF
      <p><a data-type="xref" href="#target">text</a></p>
    EOF

    assert_convert_body html, doc
  end

  def test_convert_inline_anchor_xref_with_section
    doc = <<~EOF
      <<Section>>

      [[target]]
      == Section
    EOF

    html = <<~EOF
      <p><a data-type="xref" href="#target">Section</a></p>
      <section id="target" data-type="chapter">
        <h1>Section</h1>
      </section>
    EOF

    assert_convert_body html, doc
  end

  def test_convert_inline_anchor_xref_with_refid
    doc = <<~EOF
      <<Section>>
    EOF

    html = <<~EOF
      <p><a data-type='xref' href='#Section'>[Section]</a></p>
    EOF

    assert_convert_body html, doc
  end


  def test_convert_inline_anchor_ref
    doc = <<~EOF
      [[target]] Content
    EOF

    html = <<~EOF
      <p><a id="target"></a> Content</p>
    EOF

    assert_convert_body html, doc
  end

  def test_convert_inline_anchor_link
    doc = <<~EOF
      link:http://example.com/[text]
    EOF

    html = <<~EOF
      <p><a href="http://example.com/">text</a></p>
    EOF

    assert_convert_body html, doc
  end

  def test_convert_inline_anchor_link_with_attributes
    doc = <<~EOF
      :linkattrs:

      link:http://example.com/[text, title="title" window="_blank"]
    EOF

    html = <<~EOF
      <p><a href="http://example.com/" title="title" target="_blank">text</a></p>
    EOF

    assert_convert_body html, doc
  end

  def test_convert_inline_anchor_bibref
    doc = <<~EOF
      [[[target]]] Content
    EOF

    html = <<~EOF
      <p><a id="target"></a>[target] Content</p>
    EOF

    assert_convert_body html, doc
  end
end
