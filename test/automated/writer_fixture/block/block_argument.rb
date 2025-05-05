require_relative "../../automated_init"

context "Writer Fixture" do
  context "Block" do
    context "Block Argument" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      writer.(message, stream_name)

      argument = nil
      fixture = Writer.build(writer, message.class) do |a|
        argument = a
      end

      fixture.()

      test "Is a Write fixture" do
        assert(argument.is_a?(Writer))
      end
    end
  end
end
