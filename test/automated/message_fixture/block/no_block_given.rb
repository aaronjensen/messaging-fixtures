require_relative "../../automated_init"

context "Message Fixture" do
  context "Block" do
    context "No Block Given" do
      message = Controls::Event.example

      fixture = Message.build(message)

      test "Is an error" do
        assert_raises(Message::Error) do
          fixture.()
        end
      end
    end
  end
end
