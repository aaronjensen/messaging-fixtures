require_relative "../../automated_init"

context "Message Fixture" do
  context "Message Class" do
    message = Controls::Event.example

    fixture = Message.build(message) {}

    fixture.()

    printed = fixture.test_session.detail?("Message Class: #{message.class.name}")

    test "Detailed" do
      assert(printed)
    end
  end
end
