require_relative "../../automated_init"

context "Message Fixture" do
  context "Title" do
    context "Assigned" do
      message = Controls::Event.example

      context_name = SecureRandom.hex

      fixture = Message.build(message, title_context_name: context_name) {}

      fixture.()

      context "Context Name" do
        printed = fixture.test_session.context?(context_name)

        test "Printed" do
          assert(printed)
        end
      end
    end
  end
end
