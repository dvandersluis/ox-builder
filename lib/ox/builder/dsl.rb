module Ox
  module Builder
    class DSL
      attr_reader :node

      def initialize(node)
        @node = node
      end

      def instruct!(*args)
        attributes = args.last.is_a?(Hash) ? args.pop : { version: '1.0', encoding: 'UTF-8' }
        name = args.first || :xml

        with_dsl(Ox::Instruct.new(name)) do |instruct|
          instruct.add_attributes(attributes)
          node << instruct.node
        end
      end

      def cdata!(text)
        Ox::CData.new(text)
      end

      def comment!(text)
        node << Ox::Comment.new(text)
      end

      def doctype!(type)
        node << Ox::DocType.new(type)
      end

      def tag!(name, *args, &block)
        builder = Builder.build(Ox::Element.new(name), &block).tap do |tag|
          attributes = args.last.is_a?(Hash) ? args.pop : {}

          tag.add_attributes(attributes)

          args.each do |text|
            text = text.is_a?(Ox::Node) ? text : text.to_s
            tag.node << text
          end
        end

        node << builder.node
      end

      def to_s
        Ox.dump(node)
      end
      alias_method :to_xml, :to_s

      def inspect
        "#<#{self.class.name}:0x#{"%x" % object_id} node=#{node}>"
      end

      def add_attributes(attributes)
        attributes.each do |key, val|
          node[key] = val
        end
      end

      def method_missing(name, *args, &block)
        name = name[0...-1] if name.to_s.end_with?('!')
        tag!(name, *args, &block)
      end

    protected

      def with_dsl(obj, &block)
        DSL.new(obj).tap(&block)
      end
    end
  end
end
