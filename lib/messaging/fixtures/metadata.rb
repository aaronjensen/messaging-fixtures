module Messaging
  module Fixtures
    class Metadata
      Error = Class.new(RuntimeError)

      include TestBench::Fixture
      include Initializer

      initializer :metadata, :source_metadata, :test_block

      def self.build(metadata, source_metadata=nil, &test_block)
        new(metadata, source_metadata, test_block)
      end

      def call
        context "Metadata" do
          if test_block.nil?
            raise Error, "Metadata fixture must be executed with a block"
          end

          if metadata.nil?
            test "Not nil" do
              detail "Metadata: nil"

              if not test_block.nil?
                detail "Remaining message tests are skipped"
              end

              refute(metadata.nil?)
            end
            return
          end

          test_block.call(self)
        end
      end

      def assert_attributes_assigned(attribute_names=nil, context_title_qualifier: nil)
        attribute_names ||= Messaging::Message::Metadata.all_attribute_names

        attributes_text = "Attribute"
        attributes_text = attribute_names.length == 1 ? attributes_text : "#{attributes_text}s"

        attributes_context_title = "#{context_title_qualifier} #{attributes_text} Assigned".lstrip

        fixture(
          Schema::Fixtures::Assignment,
          metadata,
          attribute_names,
          print_title_context: false,
          attributes_context_name: attributes_context_title
        )
      end

      def assert_source_attributes_assigned
        attribute_names = Messaging::Message::Metadata.source_attribute_names
        assert_attributes_assigned(attribute_names, context_title_qualifier: "Source")
      end

      def assert_workflow_attributes_assigned
        attribute_names = Messaging::Message::Metadata.workflow_attribute_names
        assert_attributes_assigned(attribute_names, context_title_qualifier: "Workflow")
      end

      def assert_causation_attributes_assigned
        attribute_names = Messaging::Message::Metadata.causation_attribute_names
        assert_attributes_assigned(attribute_names, context_title_qualifier: "Causation")
      end

      def assert_correlation_stream_name(correlation_stream_name)
        metadata_value = metadata.correlation_stream_name

        test "correlation_stream_name" do
          detail "Metadata Value: #{metadata_value}"
          detail "Compare Value: #{correlation_stream_name}"
          assert(metadata_value == correlation_stream_name)
        end
      end

      def assert_correlation_stream_name_assigned
        control_metadata = Messaging::Message::Metadata.new
        default_correlation_stream_name = control_metadata.correlation_stream_name

        correlation_stream_name = metadata.correlation_stream_name

        test "Correlation stream name assigned" do
          detail "Default Value: #{default_correlation_stream_name.inspect}"
          detail "Assigned Value: #{correlation_stream_name.inspect}"

          refute(correlation_stream_name == default_correlation_stream_name)
        end
      end

      def assert_reply_stream_name(reply_stream_name)
        metadata_value = metadata.reply_stream_name

        test "reply_stream_name" do
          detail "Metadata Value: #{metadata_value}"
          detail "Compare Value: #{reply_stream_name}"
          assert(metadata_value == reply_stream_name)
        end
      end

      def assert_reply_stream_name_assigned
        control_metadata = Messaging::Message::Metadata.new
        default_reply_stream_name = control_metadata.reply_stream_name

        reply_stream_name = metadata.reply_stream_name

        test "Reply stream name assigned" do
          detail "Default Value: #{default_reply_stream_name.inspect}"
          detail "Assigned Value: #{reply_stream_name.inspect}"

          refute(reply_stream_name == default_reply_stream_name)
        end
      end

      def assert_follows
        fixture(Follows, metadata, source_metadata)
      end
    end
  end
end
