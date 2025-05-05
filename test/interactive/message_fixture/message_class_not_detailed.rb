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
    detail_message_class: false
  ) do |message|

  end
end
