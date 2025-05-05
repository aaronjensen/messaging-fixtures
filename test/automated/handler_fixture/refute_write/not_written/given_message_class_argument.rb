require_relative "../../../automated_init"

context "Handler Fixture" do
  context "Refute Write" do
    context "Not Written" do
      context "Given Message Class Argument" do
        handler = Controls::Handler.example
        message = Controls::Message.example

        alternate_output_message_class = Controls::Event::AlternateOutput

        fixture = Handler.build(handler, message)

        fixture.refute_write(alternate_output_message_class)

        passed = fixture.test_session.test_passed?("Not written")

        test "Passed" do
          assert(passed)
        end
      end
    end
  end
end
