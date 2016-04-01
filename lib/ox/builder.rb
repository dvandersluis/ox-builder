require 'ox'
require 'docile'
require 'ox/builder/version'
require 'ox/builder/dsl'
require 'ox/builder/factory'
require 'ox/builder/fallback_context_proxy'

module Ox
  module Builder
    class << self
      def build(node = Ox::Document.new, &block)
        Factory.new(node).tap do |builder|
          dsl_eval(builder, builder, &block) if block_given?
        end
      end

    private

      def dsl_eval(dsl, *args, &block)
        Docile::Execution.exec_in_proxy_context(dsl, FallbackContextProxy, *args, &block)
      end
    end
  end
end

if defined?(Tilt)
  require 'tilt/ox_builder_template'
  Tilt.register Tilt::OxBuilderTemplate, 'ox'
end

if defined?(ActionView)
  require 'ox/builder/action_view/template_handler'
  ActionView::Template.register_template_handler :ox, Ox::Builder::ActionView::TemplateHandler.new
end
