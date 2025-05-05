require_relative "../../../automated_init"

context "Handler Fixture" do
  context "Setup" do
    context "Time" do
      context "Handler Doesn't Have a Clock" do
        input_message = Controls::Message.example

        handler = Controls::Handler.noop

        test "Fixture doesn't set the clock time to the default" do
          refute_raises(NoMethodError) do
            fixture = Handler.build(
              handler,
              input_message
            )
          end
        end
      end
    end
  end
end
