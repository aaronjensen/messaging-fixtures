require_relative "../../automated_init"

context "Message Fixture" do
  context "Title" do
    message = Controls::Event.example

    fixture = Message.build(message) {}

    fixture.()

    context "Context Name" do
      printed = fixture.test_session.context?("Message: #{message.class.message_type}")

      test "Printed" do
        assert(printed)
      end
    end
  end
end
