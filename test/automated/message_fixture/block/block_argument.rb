require_relative "../../automated_init"

context "Message Fixture" do
  context "Block" do
    context "Block Argument" do
      message = Controls::Event.example

      argument = nil
      fixture = Message.build(message) do |a|
        argument = a
      end

      fixture.()

      test "Is a Message fixture" do
        assert(argument.is_a?(Message))
      end
    end
  end
end
