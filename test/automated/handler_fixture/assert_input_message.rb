require_relative "../automated_init"

context "Handler Fixture" do
  context "Assert Input Message" do
    handler = Controls::Handler.example
    message = Controls::Message.example

    fixture = Handler.build(handler, message)

    fixture.assert_input_message {}

    context_name = "Input Message: #{message.class.message_type}"

    context "Context: #{context_name.inspect}" do
      printed = fixture.test_session.context?(context_name)

      test "Printed" do
        assert(printed)
      end
    end
  end
end
