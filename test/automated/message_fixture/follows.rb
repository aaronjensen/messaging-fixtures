require_relative "../automated_init"

context "Message Fixture" do
  context "Follows" do
    source_message = Controls::Message.example

    message_class = Controls::Event::Output

    message = message_class.follow(source_message, copy: [])

    fixture = Message.build(message, source_message)

    fixture.assert_follows

    passed = fixture.test_session.test_passed?("Follows")

    test "Passed" do
      assert(passed)
    end
  end
end
