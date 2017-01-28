$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'asciidoctor/htmlbook'
require 'minitest/autorun'
require 'rexml/document'

class ConverterTest <  Minitest::Test
  def assert_convert_equal(except, actual)
    except_html = <<~EOF
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset=\"utf-8\" />
          <title></title>
        </head>
        <body data-type="book">
          #{except}
        </body>
      </html>
    EOF

    actual_html = Asciidoctor.convert actual, backend: 'htmlbook'

    assert_equal_xhtml(pretty_format(except_html), pretty_format(actual_html))
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
