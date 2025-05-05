module Messaging
  module Fixtures
    class Message
      Error = Class.new(RuntimeError)

      include TestBench::Fixture
      include Initializer

      def message_class
        message.class
      end

      def message_type
        message_class.name.split("::").last
      end

      def source_message_class
        source_message.class
      end

      def source_message_type
        source_message_class.name.split("::").last
      end

      def print_title_context?
        if @print_title_context.nil?
          @print_title_context = true
        end
        @print_title_context
      end

      def title_context_name
        if @title_context_name.nil?
          @title_context_name = "Message"

          if not message.nil?
            @title_context_name = "#{@title_context_name}: #{message_type}"
          end
        end

        @title_context_name
      end

      def detail_message_class?
        if @detail_message_class.nil?
          @detail_message_class = true
        end
        @detail_message_class
      end

      initializer :message, :source_message, na(:print_title_context), na(:title_context_name), na(:detail_message_class), :test_block

      def self.build(message, source_message=nil, print_title_context: nil, title_context_name: nil, detail_message_class: nil, &test_block)
        new(message, source_message, print_title_context, title_context_name, detail_message_class, test_block)
      end

      def call
        if print_title_context?
          context "#{title_context_name}" do
            call!
          end
        else
          call!
        end
      end

      def call!
        if test_block.nil?
          raise Error, "Message fixture must be executed with a block"
        end

        if message.nil?
          test "Not nil" do
            detail "Message: nil"
            detail "Remaining message tests are skipped"
            refute(message.nil?)
          end
          return
        end

        if detail_message_class?
          detail "Message Class: #{message_class.name}"
        end

        if not source_message.nil?
          detail "Source Message Class: #{source_message_class.name}"
        end

        test_block.call(self)
      end

      def assert_attributes_assigned(attribute_names=nil)
        fixture(
          Schema::Fixtures::Assignment,
          message,
          attribute_names,
          print_title_context: false,
          attributes_context_name: "Attributes Assigned"
        )
      end
      alias :assert_all_attributes_assigned :assert_attributes_assigned

      def assert_attributes_copied(attribute_names=nil)
        if source_message.nil?
          test "Source message not nil" do
            detail "Source Message: nil"
            refute(source_message.nil?)
          end
          return
        end

        fixture(
          Schema::Fixtures::Equality,
          source_message,
          message,
          attribute_names,
          ignore_class: true,
          print_title_context: false,
          attributes_context_name: "Attributes Copied: #{source_message_type} => #{message_type}"
        )
      end

      def assert_metadata(&test_block)
        fixture(
          Metadata,
          message.metadata,
          source_message&.metadata,
          &test_block
        )
      end

      def assert_follows
        metadata = message.metadata
        source_metadata = source_message&.metadata

        fixture(Follows, metadata, source_metadata)
      end

      def assert_attribute_value(name, value)
        context "Attribute Value" do
          assert_attribute_value!(name, value)
        end
      end

      def assert_attribute_value!(name, value)
        attribute_value = message.public_send(name)

        test "#{name}" do
          detail "Attribute Value: #{attribute_value.inspect}"
          detail "Compare Value: #{value.inspect}"

          assert(attribute_value == value)
        end
      end

      def assert_attribute_values(attributes)
        context "Attribute Values" do
          attributes.each do |name, value|
            assert_attribute_value!(name, value)
          end
        end
      end
    end
  end
end

