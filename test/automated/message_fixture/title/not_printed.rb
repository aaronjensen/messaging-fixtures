require_relative "../../automated_init"

context "Message Fixture" do
  context "Title" do
    message = Controls::Event.example

    fixture = Message.build(message, print_title_context: false) {}

    fixture.()

    context "Context Name" do
      printed = fixture.test_session.context?("Message: #{message.class.message_type}")

      test "Not Printed" do
        refute(printed)
      end
    end
  end
end
