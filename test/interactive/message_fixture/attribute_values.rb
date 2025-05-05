require_relative "../interactive_init"

context "Message Fixture" do
  context "Assert Attribute Values" do
    message = Controls::Event.example

    example_id = message.example_id
    amount = message.amount
    time = message.time
    processed_time = message.processed_time
    sequence = message.sequence

    fixture(
      Message,
      message
    ) do |message|

      message.assert_attribute_values(
        example_id: example_id,
        amount: amount,
        time: time,
        processed_time: processed_time,
        sequence: sequence
      )

    end
  end
end
