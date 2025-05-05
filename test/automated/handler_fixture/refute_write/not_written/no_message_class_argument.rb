require_relative "../../../automated_init"

context "Handler Fixture" do
  context "Refute Write" do
    context "Not Written" do
      context "No Message Class Argument Given" do
        handler = Controls::Handler.example
        message = Controls::Message.example

        fixture = Handler.build(handler, message)

        fixture.refute_write

        passed = fixture.test_session.test_passed?("Not written")

        test "Passed" do
          assert(passed)
        end
      end
    end
  end
end
