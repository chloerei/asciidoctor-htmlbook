module Asciidoctor
  module Htmlbook
    class Converter < Asciidoctor::Converter::Base
      register_for "htmlbook"

      DEFAULT_TEMPLATE_PATH = File.expand_path('../../../../templates', __FILE__)

      def initialize(backend, options = {})
        super
        @templates = {}
      end

      def get_template(node_name)
        return @templates[node_name] if @templates[node_name]

        path = File.join DEFAULT_TEMPLATE_PATH, "#{node_name}.html"
        if File.exist?(path)
          @templates[node_name] = Liquid::Template.parse(File.read(path))
        end
      end

      def convert(node, transform = nil, options = {})
        template = get_template(node.node_name)

        unless template
          raise "Template not found #{node.node_name} #{node} #{node.attributes}"
        end

        template.render 'node' => node_to_liquid(node)
      end

      def node_to_liquid(node)
        case node
        when Asciidoctor::Document
          document_to_liquid(node)
        when Asciidoctor::Section
          section_to_liquid(node)
        when Asciidoctor::Block
          block_to_liquid(node)
        when Asciidoctor::List
          list_to_liquid(node)
        when Asciidoctor::Table
          table_to_liquid(node)
        when Asciidoctor::Inline
          inline_to_liquid(node)
        else
          raise "Uncatch type #{node} #{node.attributes}"
        end
      end

      def abstract_node_to_liquid(node)
        {
          'context' => node.context.to_s,
          'node_name' => node.node_name,
          'id' => node.id,
          'attributes' => node.attributes,
          'document' => {
            'references' => {
              'ids' => node.document.references[:ids]
            }
          }
        }
      end

      def abstract_block_to_liquid(node)
        abstract_node_to_liquid(node).merge({
          'level' => node.level,
          'title' => node.title,
          'style' => node.style,
          'caption' => node.caption,
          'content' => node.content
        })
      end

      def document_to_liquid(node)
        abstract_block_to_liquid(node).merge({
          'header' => {
            'title' => (node.header && node.header.title)
          }
        })
      end

      def section_to_liquid(node)
        abstract_block_to_liquid(node).merge({
          'index' => node.index,
          'number' => node.number,
          'sectname' => node.sectname,
          'special' => node.special,
          'numbered' => node.numbered
        })
      end

      def block_to_liquid(node)
        abstract_block_to_liquid(node).merge({
          'blockname' => node.blockname
        })
      end

      def list_to_liquid(node)
        abstract_block_to_liquid(node).merge({
          'items' => node.blocks.map { |item| listitem_to_liquid(item) }
        })
      end

      def table_to_liquid(node)
        abstract_block_to_liquid(node).merge({
          'columns' => node.columns,
          'rows' => {
            'head' => node.rows.head.map { |row| row.map {|cell| cell_to_liquid(cell) } },
            'body' => node.rows.body.map { |row| row.map {|cell| cell_to_liquid(cell) } },
            'foot' => node.rows.foot.map { |row| row.map {|cell| cell_to_liquid(cell) } }
          }
        })
      end

      def cell_to_liquid(node)
        abstract_node_to_liquid(node).merge({
          'text' => node.text,
          'content' => node.content,
          'style' => node.style,
          'colspan' => node.colspan,
          'rowspan' => node.rowspan
        })
      end

      def listitem_to_liquid(node)
        abstract_block_to_liquid(node).merge({
          'text' => node.text
        })
      end

      def inline_to_liquid(node)
        abstract_node_to_liquid(node).merge({
          'text' => node.text,
          'type' => node.type.to_s,
          'target' => node.target
        })
      end
    end
  end
end
