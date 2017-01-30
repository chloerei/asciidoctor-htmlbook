require 'test_helper'

class Asciidoctor::Htmlbook::Converter::InlineFootnoteTest < ConverterTest
  def test_convert_toc_auto
    doc = <<~EOF
      = Book Title
      :toc: macro

      [preface]
      == Preface

      toc::[]

      == Chapter One

      === Section One

      == Chapter Two
    EOF

    html = <<~EOF
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset='utf-8'/>
          <title>Book Title</title>
        </head>
        <body data-type='book'>
          <section id='_preface' data-type='preface'>
            <h1>Preface</h1>
            <nav data-type='toc'>
              <h1>Table of Contents</h1>
              <ol>
                <li>
                  <a href='#_preface'>Preface</a>
                </li>
                <li>
                  <a href='#_chapter_one'>Chapter One</a>
                  <ol>
                    <li>
                      <a href='#_section_one'>Section One</a>
                    </li>
                  </ol>
                </li>
                <li>
                  <a href='#_chapter_two'>Chapter Two</a>
                </li>
              </ol>
            </nav>
          </section>
          <section id='_chapter_one' data-type='chapter'>
            <h1>Chapter One</h1>
            <section id='_section_one' data-type='sect1'>
              <h1>Section One</h1>
            </section>
          </section>
          <section id='_chapter_two' data-type='chapter'>
            <h1>Chapter Two</h1>
          </section>
        </body>
      </html>
    EOF

    assert_convert_html html, doc
  end

  def test_convert_toc_with_sectnum
    doc = <<~EOF
      = Book Title
      :toc: macro

      :sectnums!:

      [preface]
      == Preface

      toc::[]

      :sectnums:

      == Chapter One

      === Section One

      == Chapter Two
    EOF

    html = <<~EOF
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset='utf-8'/>
          <title>Book Title</title>
        </head>
        <body data-type='book'>
          <section id='_preface' data-type='preface'>
            <h1>Preface</h1>
            <nav data-type='toc'>
              <h1>Table of Contents</h1>
              <ol>
                <li>
                  <a href='#_preface'>Preface</a>
                </li>
                <li>
                  <a href='#_chapter_one'>1. Chapter One</a>
                  <ol>
                    <li>
                      <a href='#_section_one'>1.1. Section One</a>
                    </li>
                  </ol>
                </li>
                <li>
                  <a href='#_chapter_two'>2. Chapter Two</a>
                </li>
              </ol>
            </nav>
          </section>
          <section id='_chapter_one' data-type='chapter'>
            <h1>Chapter One</h1>
            <section id='_section_one' data-type='sect1'>
              <h1>Section One</h1>
            </section>
          </section>
          <section id='_chapter_two' data-type='chapter'>
            <h1>Chapter Two</h1>
          </section>
        </body>
      </html>
    EOF

    assert_convert_html html, doc
  end
end
