module Ox
  module Builder
    class FallbackContextProxy < Docile::FallbackContextProxy
      def method_missing(method, *args, &block)
        if @__receiver__.respond_to?(method.to_sym)
          @__receiver__.__send__(method.to_sym, *args, &block)
        elsif @__fallback__.respond_to?(method.to_sym)
          @__fallback__.__send__(method.to_sym, *args, &block)
        else
          # If neither the receiver or the fallback define the method, call it on the receiver
          # This allows tags to be
          @__receiver__.__send__(method.to_sym, *args, &block)
        end
      end
    end
  end
end
