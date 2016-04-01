module Ox
  module Builder
    class FallbackContextProxy < Docile::FallbackContextProxy
      DSL_METHODS = DSL.instance_methods(false)

      def method_missing(method, *args, &block)
        # This is somewhat more complicated than the normal FallbackContextProxy provided by
        # docile. The reason for this is that the Builder has its own method_missing to
        # allow tags to be defined dynamically, but that can't define a respond_to_missing?
        # because we don't know what the methods will be until they are accessed.
        #
        # Therefore, if the fallback doesn't respond to the method, send it to the receiver
        # regardless of if it responds to it or not (so that its method_missing can pick it up).
        #
        # The next wrinkle is that we need to try the fallback before the receiver or else
        # nested DSLs lose access to methods defined in the original scope. To handle this
        # without allowing the core DSL methods to be clobbered, we first check if the method
        # is a DSL method and if so pass it directly to the receiver.

        if DSL_METHODS.include?(method.to_sym)
          @__receiver__.__send__(method.to_sym, *args, &block)
        elsif @__fallback__.respond_to?(method.to_sym)
          @__fallback__.__send__(method.to_sym, *args, &block)
        else
          @__receiver__.__send__(method, *args, &block)
        end
      end
    end
  end
end
