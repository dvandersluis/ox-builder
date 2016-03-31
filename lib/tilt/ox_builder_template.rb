require 'tilt/template'
require 'ox/builder'

module Tilt
  class OxBuilderTemplate < Template
    self.default_mime_type = 'text/xml'

    def self.engine_initialized?
      defined? ::Ox::Builder
    end

    def initialize_engine
      require_template_library 'ox-builder'
    end

    def prepare
      @code =<<-RUBY
        Ox::Builder.build do
          #{data}
        end.to_xml
      RUBY
    end

    def precompiled_template(locals)
      @code
    end
  end
end
