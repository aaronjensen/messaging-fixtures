require_relative "../../interactive_init"

context "Message Fixture" do
  context "Assert Attributes Copied" do
    source_message = Controls::Message.example

    message_class = Controls::Event::Output

    attribute_names = [
      :example_id,
      { :quantity => :amount },
      :time,
    ]

    message = message_class.follow(source_message, copy: attribute_names)

    message.processed_time = Controls::Event.processed_time
    message.sequence = Controls::Event.sequence

    fixture(
      Message,
      message,
      source_message
    ) do |message|

      message.assert_attributes_copied(attribute_names)

    end
  end
end
