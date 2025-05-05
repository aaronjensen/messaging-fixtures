require_relative "../../automated_init"

context "Handler Fixture" do
  context "Block" do
    context "No Block Given" do
      handler = Controls::Handler.example
      message = Controls::Message.example

      fixture = Handler.build(handler, message)

      test "Is an error" do
        assert_raises(Handler::Error) do
          fixture.()
        end
      end
    end
  end
end
