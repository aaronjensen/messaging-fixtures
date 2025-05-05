require_relative "../../automated_init"

context "Handler Fixture" do
  context "Assert Write" do
    context "Return Value" do
      handler = Controls::Handler.example
      message = Controls::Message.example

      output_message_class = Controls::Event::Output

      fixture = Handler.build(handler, message) {}

      fixture.()

      result = fixture.assert_write(output_message_class) {}

      context "Result" do
        test "Is the output message" do
          assert(result.is_a?(output_message_class))
        end
      end
    end
  end
end
