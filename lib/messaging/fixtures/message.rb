module Messaging
  module Fixtures
    class Message
      include TestBench::Fixture
      include Initializer

      def message_class
        message.class
      end

      def message_type
        message_class.name.split('::').last
      end

      def source_message_class
        source_message.class
      end

      def source_message_type
        source_message_class.name.split('::').last
      end

      def title_context_name
        @title_context_name ||= "Message"
      end

      initializer :message, :source_message, na(:title_context_name), :action

      def self.build(message, source_message=nil, title_context_name: nil, &action)
        new(message, source_message, title_context_name, action)
      end

      def call
        context_title = title_context_name

        context context_title do
          if message.nil?
            test "Not nil" do
              detail "Message: nil"

              if not action.nil?
                detail "Remaining message tests are skipped"
              end

              refute(message.nil?)
            end
            return
          end

          detail "Message Class: #{message_class.name}"

          if not source_message.nil?
            detail "Source Message Class: #{source_message_class.name}"
          end

          if not action.nil?
            action.call(self)
          end
        end
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

      def assert_metadata(&action)
        fixture(
          Metadata,
          message.metadata,
          source_message&.metadata,
          &action
        )
      end

      def assert_follows
        metadata = message.metadata
        source_metadata = source_message&.metadata

        fixture(Follows, metadata, source_metadata)
      end
    end
  end
end
