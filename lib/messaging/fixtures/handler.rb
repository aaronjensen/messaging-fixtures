module Messaging
  module Fixtures
    class Handler
      Error = Class.new(RuntimeError)

      include TestBench::Fixture
      include Initializer

      def entity_sequence
        return nil if entity.nil?
        entity.sequence
      end

      initializer :handler, :input_message, :entity, :entity_version, :entity_id, :clock_time, :identifier_uuid, :test_block

      def self.build(handler, input_message, entity=nil, entity_version=nil, entity_id: nil, clock_time: nil, identifier_uuid: nil, &test_block)
        instance = new(handler, input_message, entity, entity_version, entity_id, clock_time, identifier_uuid, test_block)

        set_store_entity(handler, entity, entity_version, entity_id)
        set_clock_time(handler, clock_time)
        set_identifier_uuid(handler, identifier_uuid)

        instance
      end

      def self.set_store_entity(handler, entity, entity_version, entity_id)
        return if entity.nil?

        entity_id ||= entity.id

        handler.store.add(entity_id, entity, entity_version)
      end

      def self.set_clock_time(handler, clock_time)
        if clock_time.nil?
          if handler.respond_to?(:clock)
            handler.clock.now = Defaults.clock_time
          end
        else
          handler.clock.now = clock_time
        end
      end

      def self.set_identifier_uuid(handler, identifier_uuid)
        if identifier_uuid.nil?
          if handler.respond_to?(:identifier)
            handler.identifier.set(Defaults.identifier_uuid)
          end
        else
          handler.identifier.set(identifier_uuid)
        end
      end

      def call
        context "Handler: #{handler.class.name.split("::").last}" do
          detail "Handler Class: #{handler.class.name}"

          if test_block.nil?
            raise Error, "Handler fixture must be executed with a block"
          end

          detail "Entity Class: #{entity.class.name}"
          detail "Entity Data: #{entity&.attributes.inspect}"

          if not clock_time.nil?
            detail "Clock Time: #{clock_time.inspect}"
          end

          if not identifier_uuid.nil?
            detail "Identifier UUID: #{identifier_uuid}"
          end

          handler.(input_message)

          test_block.call(self)
        end
      end

      def assert_input_message(&test_block)
        context_name = "Input Message"
        if not input_message.nil?
          context_name = "#{context_name}: #{input_message.class.message_type}"
        end

        fixture(Message, input_message, title_context_name: context_name, &test_block)
      end

      def assert_written_message(written_message, &test_block)
        context_name = "Written Message"
        if not written_message.nil?
          context_name = "#{context_name}: #{written_message.class.message_type}"
        end

        fixture(Message, written_message, input_message, title_context_name: context_name, &test_block)
      end

      def assert_write(message_class, &test_block)
        fixture = fixture(Writer, handler.write, message_class, &test_block)
        fixture.message
      end

      def refute_write(message_class=nil)
        writer = handler.write

        context_name = "No Write"
        if not message_class.nil?
          write_telemetry_data = Writer.get_data(writer, message_class)
          written = !write_telemetry_data.nil?
          context_name = "#{context_name}: #{message_class.message_type}"
        else
          written = writer.written?
        end

        context context_name do
          detail "Message Class: #{message_class.inspect}"
          test "Not written" do
            refute(written)
          end
        end
      end
    end
  end
end
