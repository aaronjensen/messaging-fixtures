require_relative "../../automated_init"

context "Handler Fixture" do
  context "Assert Write" do
    context "Message Is Written" do
      handler = Controls::Handler.example
      message = Controls::Message.example

      output_message_class = Controls::Event::Output

      fixture = Handler.build(handler, message) {}

      fixture.()

      fixture.assert_write(output_message_class) {}

      passed = fixture.test_session.test_passed?("Written")

      test "Passed" do
        assert(passed)
      end
    end
  end
end
