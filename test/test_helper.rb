$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'asciidoctor/htmlbook'
require 'minitest/autorun'
require 'rexml/document'

class ConverterTest <  Minitest::Test
  def assert_convert_body(html, doc)
    except_html = <<~EOF
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset=\"utf-8\" />
          <title></title>
        </head>
        <body data-type="book">
          #{html}
        </body>
      </html>
    EOF

    actual_html = Asciidoctor.convert doc, backend: 'htmlbook'

    assert_equal pretty_format(except_html), pretty_format(actual_html)
  end

  def assert_convert_html(html, doc)
    actual_html = Asciidoctor.convert doc, backend: 'htmlbook'

    assert_equal pretty_format(html), pretty_format(actual_html)
  end

  def pretty_format(html)
    out = ""
    REXML::Document.new(html).write(out, 2)
    out.gsub(/\s*$/, '')
  rescue
    puts html
    raise
  end
end
