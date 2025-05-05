require_relative "../../automated_init"

context "Handler Fixture" do
  context "Block" do
    context "Block Argument" do
      handler = Controls::Handler.example
      message = Controls::Message.example

      argument = nil
      fixture = Handler.build(handler, message) do |a|
        argument = a
      end

      fixture.()

      test "Is a Handler fixture" do
        assert(argument.is_a?(Handler))
      end
    end
  end
end
