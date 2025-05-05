require_relative "../../../automated_init"

context "Handler Fixture" do
  context "Refute Write" do
    context "Written" do
      context "No Message Class Argument Given" do
        handler = Controls::Handler.example
        message = Controls::Message.example

        output_message_class = Controls::Event::Output

        fixture = Handler.build(handler, message) {}

        fixture.()

        fixture.refute_write(output_message_class)

        failed = fixture.test_session.test_failed?("Not written")

        test "Failed" do
          assert(failed)
        end
      end
    end
  end
end
