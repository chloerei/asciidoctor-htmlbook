require 'test_helper'

class Asciidoctor::Htmlbook::Converter::ListingTest < ConverterTest
  def test_convert_listing
    doc = <<~EOF
      [source]
      ----
      def hello
        puts "hello world!"
      end
      ----
    EOF

    html = <<~EOF
      <figure>
        <pre data-type="programlisting">def hello
          puts "hello world!"
        end</pre>
      </figure>
    EOF

    assert_convert_body html, doc
  end

  def test_convert_listing_with_attributes
    doc = <<~EOF
      [[id]]
      [source, ruby]
      .Title
      ----
      def hello
        puts "hello world!"
      end
      ----
    EOF

    html = <<~EOF
      <figure>
        <figcaption>Title</figcaption>
        <pre data-type="programlisting" data-code-language="ruby" id="id">def hello
          puts "hello world!"
        end</pre>
      </figure>
    EOF

    assert_convert_body html, doc
  end

end
