require 'test_helper'

class Asciidoctor::Htmlbook::Converter::SidebarTest < Minitest::Test
  include ConverterTestHelper

  def test_convert_sidebar
    doc = <<~EOF
      .Sidebar Title
      [[sidebar]]
      ****
      Sidebar content.
      ****
    EOF

    html = <<~EOF
      <aside data-type="sidebar" id="sidebar">
        <h5>Sidebar Title</h5>
        <p>Sidebar content.</p>
      </aside>
    EOF

    assert_convert_body html, doc
  end
end
