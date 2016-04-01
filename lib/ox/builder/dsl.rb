module Ox
  module Builder
    module DSL
      def instruct!(*args)
        attributes = args.last.is_a?(Hash) ? args.pop : { version: '1.0', encoding: 'UTF-8' }
        name = args.first || :xml

        with_dsl(Ox::Instruct.new(name)) do |instruct|
          instruct.add_attributes(attributes)
          node << instruct.node
        end
      end

      def cdata!(text)
        node << Ox::CData.new(text)
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
    end
  end
end
