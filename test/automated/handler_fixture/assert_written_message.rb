require_relative "../automated_init"

context "Handler Fixture" do
  context "Assert Written Message" do
    handler = Controls::Handler.example
    message = Controls::Message.example
    event = Controls::Event.example

    fixture = Handler.build(handler, message)

    fixture.assert_written_message(event) {}

    context_name = "Written Message: #{event.class.message_type}"

    context "Context: #{context_name.inspect}" do
      printed = fixture.test_session.context?(context_name)

      test "Printed" do
        assert(printed)
      end
    end
  end
end
