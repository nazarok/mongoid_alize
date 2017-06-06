module Mongoid
  module Alize
    class FromCallback < Callback

      def attach
        define_mongoid_field
        define_denorm_attrs

        define_callback
        alias_callback
        set_callback
      end

      def set_callback
        unless callback_attached?("save", aliased_callback_name)
          klass.set_callback(:save, :before, aliased_callback_name.to_sym)
        end
      end

      def ensure_field_not_defined!(prefixed_name, klass)
        if field_defined?(prefixed_name, klass)
          raise Mongoid::Alize::Errors::AlreadyDefinedField.new(prefixed_name, klass.name)
        end
      end

      def field_defined?(prefixed_name, klass)
        !!klass.fields[prefixed_name]
      end

      def prefixed_name
        "#{relation}_fields"
      end

      def direction
        "from"
      end
    end
  end
end
