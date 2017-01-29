require 'test_helper'

class Asciidoctor::Htmlbook::Converter::QuoteTest < ConverterTest
  def test_convert_quote
    doc = <<~EOF
      ____
      Quote content.
      ____
    EOF

    html = <<~EOF
      <blockquote>
        <p>Quote content.</p>
      </blockquote>
    EOF

    assert_convert_equal html, doc
  end

  def test_convert_quote_with_attribution
    doc = <<~EOF
      [quote, Monty Python and the Holy Grail]
      ____
      Dennis: Come and see the violence inherent in the system. Help! Help! I'm being repressed!

      King Arthur: Bloody peasant!

      Dennis: Oh, what a giveaway! Did you hear that? Did you hear that, eh? That's what I'm on about! Did you see him repressing me? You saw him, Didn't you?
      ____
    EOF

    html = <<~EOF
      <blockquote>
        <p>Dennis: Come and see the violence inherent in the system. Help! Help! I&#8217;m being repressed!</p>
        <p>King Arthur: Bloody peasant!</p>
        <p>Dennis: Oh, what a giveaway! Did you hear that? Did you hear that, eh? That&#8217;s what I&#8217;m on about! Did you see him repressing me? You saw him, Didn&#8217;t you?</p>
        <p data-type="attribution">Monty Python and the Holy Grail</p>
      </blockquote>
    EOF

    assert_convert_equal html, doc
  end
end
