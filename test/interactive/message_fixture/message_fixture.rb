require_relative "../interactive_init"

context "Message Fixture" do
  source_message = Controls::Message.example

  message_class = Controls::Event::Output

  attribute_names = [
    :example_id,
    { :quantity => :amount },
    :time,
  ]

  source_message.metadata.correlation_stream_name = "someCorrelationStream"
  source_message.metadata.reply_stream_name = "someReplyStream"

  message = message_class.follow(source_message, copy: attribute_names)

  processed_time = Controls::Event.processed_time
  sequence = Controls::Event.sequence

  message.processed_time = processed_time
  message.sequence = sequence

  fixture(
    Message,
    message,
    source_message
  ) do |message|

    message.assert_attributes_copied(attribute_names)

    message.assert_attribute_value(:processed_time, processed_time)
    message.assert_attribute_value(:sequence, sequence)

    message.assert_follows

    message.assert_attributes_assigned

    message.assert_metadata do |metadata|
      metadata.assert_correlation_stream_name("someCorrelationStream")
      metadata.assert_reply_stream_name("someReplyStream")
    end
  end
end
