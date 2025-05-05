require_relative "../../automated_init"

context "Handler Fixture" do
  context "Assert Write" do
    context "Message Is Not Written" do
      handler = Controls::Handler.example
      message = Controls::Message.example

      output_message_class = Class.new do
        include Messaging::Message
      end

      fixture = Handler.build(handler, message) {}

      fixture.()

      fixture.assert_write(output_message_class) {}

      failed = fixture.test_session.test_failed?("Written")

      test "Failed" do
        assert(failed)
      end
    end
  end
end
