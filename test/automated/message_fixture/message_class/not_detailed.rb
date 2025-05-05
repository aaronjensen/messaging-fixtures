require_relative "../../automated_init"

context "Message Fixture" do
  context "Message Class" do
    message = Controls::Event.example

    fixture = Message.build(message, detail_message_class: false) {}

    fixture.()

    detailed = fixture.test_session.detail?("Message Class: #{message.class.name}")

    test "Not Detailed" do
      refute(detailed)
    end
  end
end
