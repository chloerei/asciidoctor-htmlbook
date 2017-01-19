require 'test_helper'
require 'rexml/document'

class Asciidoctor::Htmlbook::ConverterTest < Minitest::Test
  def setup
    @doc = Asciidoctor::Document.new nil, backend: 'htmlbook'
  end

  def test_convert_empty_document
    assert_equal_xhtml <<~EOF, @doc.convert
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset=\"utf-8\" />
          <title></title>
        </head>
        <body data-type="book">
        </body>
      </html>
    EOF
  end

  def test_convert_section_part
    section = Asciidoctor::Section.new @doc
    section.sectname = 'sect0'
    section.title = 'Part Title'
    section.id = "_part0"
    assert_equal_xhtml <<~EOF, section.convert
      <section id="_part0" data-type="part">
        <h1>Part Title</h1>
      </section>
    EOF
  end

  def test_convert_section_sect1
    section = Asciidoctor::Section.new @doc
    section.sectname = 'sect1'
    section.title = 'Chapter Title'
    section.id = "_chapter1"
    assert_equal_xhtml <<~EOF, section.convert
      <section id="_chapter1" data-type="chapter">
        <h1>Chapter Title</h1>
      </section>
    EOF
  end

  def test_convert_section_sect2
    section = Asciidoctor::Section.new @doc
    (1..5).each do |level|
      section.sectname = "sect#{level + 1}"
      section.title = 'Section Title'
      section.id = "_sect#{level}"
      assert_equal_xhtml <<~EOF, section.convert
        <section id="_sect#{level}" data-type="sect#{level}">
          <h#{level}>Section Title</h#{level}>
        </section>
      EOF
    end
  end

  def test_convert_section_preface
    section = Asciidoctor::Section.new @doc
    section.sectname = 'preface'
    section.title = 'Preface Title'
    section.id = '_preface'
    assert_equal_xhtml <<~EOF, section.convert
      <section id="_preface" data-type="preface">
        <h1>Preface Title</h1>
      </section>
    EOF
  end

  def test_convert_paragraph
    block = Asciidoctor::Block.new @doc, :paragraph, source: 'Text'
    assert_equal_xhtml <<~EOF, block.convert
      <p>Text</p>
    EOF
  end

  def test_convert_indexterm_visible
    inline = Asciidoctor::Inline.new @doc, :indexterm, 'term', type: :visible
    assert_equal_xhtml <<~EOF, inline.convert
      <a data-type="indexterm">term</a>
    EOF
  end

  def test_convert_indexterm_invisible
    inline = Asciidoctor::Inline.new @doc, :indexterm, nil, attributes: { 'terms' => ['primary', 'secondary', 'tertiary']}
    assert_equal_xhtml <<~EOF, inline.convert
      <a data-type="indexterm" data-primary="primary" data-secondary="secondary" data-tertiary="tertiary" />
    EOF
  end

  def test_convert_inline_quoted
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :emphasis).convert
      <em>text</em>
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :strong).convert
      <strong>text</strong>
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :monospaced).convert
      <code>text</code>
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :superscript).convert
      <sup>text</sup>
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :subscript).convert
      <sub>text</sub>
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :double).convert
      &#8220;text&#8221;
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :single).convert
      &#8216;text&#8217;
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :mark).convert
      <mark>text</mark>
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :asciimath).convert
      \\$text\\$
    EOF
    assert_equal_xhtml <<~EOF, Asciidoctor::Inline.new(@doc, :quoted, 'text', type: :latexmath).convert
      \\text\\
    EOF
  end

  def test_convert_image
    assert_equal_xhtml <<~EOF, Asciidoctor::Block.new(@doc, :image, attributes: { 'target' => 'http://example.com/logo.png'}).convert
      <figure>
        <img src="http://example.com/logo.png" />
      </figure>
    EOF

    assert_equal_xhtml <<~EOF, Asciidoctor::Block.new(@doc, :image, attributes: { 'target' => 'http://example.com/logo.png', 'alt' => 'logo', 'title' => 'Image Title'}).convert
      <figure>
        <img src="http://example.com/logo.png" alt="logo" />
        <figcaption>Image Title</figcaption>
      </figure>
    EOF
  end

  def test_convert_ulist
    ulist = Asciidoctor::List.new @doc, :ulist
    3.times { ulist.blocks << Asciidoctor::ListItem.new(ulist, 'listitem') }
    assert_equal_xhtml <<~EOF, ulist.convert
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
  end

  def test_convert_ulist_nested
    ulist = Asciidoctor::List.new @doc, :ulist
    ulist.blocks << Asciidoctor::ListItem.new(ulist, 'listitem')
    ulist.blocks.first.blocks << Asciidoctor::List.new(@doc, :ulist)
    ulist.blocks.first.blocks.first.blocks << Asciidoctor::ListItem.new(ulist.blocks.first.blocks.first, 'listitem')
    ulist.blocks << Asciidoctor::ListItem.new(ulist, 'listitem')

    assert_equal_xhtml <<~EOF, ulist.convert
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
  end

  def test_convert_olist
    olist = Asciidoctor::List.new @doc, :olist
    3.times { olist.blocks << Asciidoctor::ListItem.new(olist, 'listitem') }
    assert_equal_xhtml <<~EOF, olist.convert
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
  end

  def test_convert_olist_nested
    olist = Asciidoctor::List.new @doc, :olist
    olist.blocks << Asciidoctor::ListItem.new(olist, 'listitem')
    olist.blocks.first.blocks << Asciidoctor::List.new(@doc, :olist)
    olist.blocks.first.blocks.first.blocks << Asciidoctor::ListItem.new(olist.blocks.first.blocks.first, 'listitem')
    olist.blocks << Asciidoctor::ListItem.new(olist, 'listitem')

    assert_equal_xhtml <<~EOF, olist.convert
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
  end

  def test_inline_anchor_xref
    anchor = Asciidoctor::Inline.new(@doc, :anchor, nil, :type => :xref, :target => '#target', :attributes => { 'refid' => 'refid' })
    assert_equal_xhtml <<~EOF, anchor.convert
      <a data-type="xref" href="#target">[refid]</a>
    EOF

    @doc.instance_variable_set :@references, { ids: { 'refid' => 'Ref Title' } }
    anchor = Asciidoctor::Inline.new(@doc, :anchor, nil, type: :xref, target: '#target', attributes: { 'refid' => 'refid' })
    assert_equal_xhtml <<~EOF, anchor.convert
      <a data-type="xref" href="#target">Ref Title</a>
    EOF

    anchor = Asciidoctor::Inline.new(@doc, :anchor, 'text', type: :xref, target: '#target', attributes: { 'refid' => 'refid' })
    assert_equal_xhtml <<~EOF, anchor.convert
      <a data-type="xref" href="#target">text</a>
    EOF
  end

  def test_inline_anchor_ref
    anchor = Asciidoctor::Inline.new(@doc, :anchor, nil, type: :ref, target: 'target')
    assert_equal_xhtml <<~EOF, anchor.convert
      <a id="target"></a>[target]
    EOF
  end

  def test_inline_anchor_link
    anchor = Asciidoctor::Inline.new(@doc, :anchor, 'text', type: :link, target: 'http://example.com/')
    assert_equal_xhtml <<~EOF, anchor.convert
      <a href="http://example.com/">text</a>
    EOF

    anchor = Asciidoctor::Inline.new(@doc, :anchor, 'text', type: :link, target: 'http://example.com/', attributes: { 'title' => 'title', 'window' => '_blank' })
    assert_equal_xhtml <<~EOF, anchor.convert
      <a href="http://example.com/" title="title" target="_blank">text</a>
    EOF
  end

  def test_inline_anchor_bibref
    anchor = Asciidoctor::Inline.new(@doc, :anchor, 'text', type: :bibref, target: 'target')
    assert_equal_xhtml <<~EOF, anchor.convert
      <a id="target"></a>[text]
    EOF
  end

  def test_convert_listing
    listing = Asciidoctor::Block.new(@doc, :listing, content_model: :verbatim, source: <<~EOF)
      def hello
        puts "hello world!"
      end
    EOF
    assert_equal_xhtml <<~EOF, listing.convert
      <figure>
        <pre data-type="programlisting">def hello
          puts "hello world!"
        end</pre>
      </figure>
    EOF

    listing.id = 'listing'
    listing.title = 'Listing'
    listing.attributes['language'] = 'ruby'
    assert_equal_xhtml <<~EOF, listing.convert
      <figure>
        <figcaption>Listing</figcaption>
        <pre data-type="programlisting" data-code-language="ruby" id="listing">def hello
          puts "hello world!"
        end</pre>
      </figure>
    EOF
  end

  def assert_equal_xhtml(except, actual)
    assert_equal pretty_format(except), pretty_format(actual)
  end

  def pretty_format(html)
    out = ""
    REXML::Document.new(html).write(out, 2)
    out.gsub(/^\s*\n/, '')
  rescue
    puts html
    raise
  end
end
