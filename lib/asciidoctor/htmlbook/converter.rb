
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
        else
          raise "Template not found: #{node_name}"
        end
      end

      def convert(node, transform = nil, options = {})
        template = get_template(node.node_name)
        case node
        when Asciidoctor::Document
          template.render 'node' => { 'doctitle' => node.doctitle, 'content' => node.content }
        when Asciidoctor::AbstractBlock
          template.render 'node' => { 'title' => node.title, 'content' => node.content }
        when Asciidoctor::Inline
          template.render 'node' => { 'text' => node.text }
        else
          raise "Uncatch type"
        end
      end
    end
  end
end
