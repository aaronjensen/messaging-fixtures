require_relative "../interactive_init"

context "Handler Fixture" do
  handler = Controls::Handler.example
  message = Controls::Message.example

  entity = Controls::Entity::Identified.example

  message_sequence = message.metadata.global_position
  entity.sequence = message_sequence - 1

  entity_version = 11

  output_message_class = Controls::Event::Output
  output_stream_name = "example-#{entity.id}"

  alternate_output_message_class = Controls::Event::AlternateOutput

  clock_time = Controls::Time::Processed::Raw.example
  identifier_uuid = Controls::ID.example

  fixture(
    Handler,
    handler,
    message,
    entity,
    entity_version,
    clock_time: clock_time,
    identifier_uuid: identifier_uuid
  ) do |handler|

    handler.assert_input_message do |input_message|
      input_message.assert_all_attributes_assigned

      input_message.assert_metadata do |metadata|
        metadata.assert_source_attributes_assigned
      end
    end

    message = handler.assert_write(output_message_class) do |write|
      write.assert_stream_name(output_stream_name)
      write.assert_expected_version(entity_version)
    end

    handler.assert_written_message(message) do |written_message|
      written_message.assert_follows

      written_message.assert_attributes_copied([
        :example_id,
        { :quantity => :amount },
        :time,
      ])

      written_message.assert_attribute_value(:processed_time, Clock.iso8601(clock_time))
      written_message.assert_attribute_value(:sequence, message_sequence)

      written_message.assert_all_attributes_assigned

      written_message.assert_metadata do |metadata|
        metadata.assert_correlation_stream_name("someCorrelationStream")
        metadata.assert_reply_stream_name("someReplyStream")
      end
    end

    handler.refute_write(alternate_output_message_class)
  end
end
