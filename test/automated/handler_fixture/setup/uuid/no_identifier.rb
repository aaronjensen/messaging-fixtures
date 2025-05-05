require_relative "../../../automated_init"

context "Handler Fixture" do
  context "Setup" do
    context "UUID" do
      context "Handler Doesn't Have an Identifier" do
        input_message = Controls::Message.example

        handler = Controls::Handler.noop

        test "Fixture doesn't set the UUID to the default" do
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
