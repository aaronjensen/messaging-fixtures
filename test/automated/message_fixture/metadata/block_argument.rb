require_relative "../../automated_init"

context "Message Fixture" do
  context "Assert Metadata" do
    context "Block Argument" do
      message = Controls::Event.example

      fixture = Message.build(message)

      argument = nil
      fixture.assert_metadata do |a|
        argument = a
      end

      test "Is a Metadata fixture" do
        assert(argument.is_a?(Metadata))
      end
    end
  end
end
