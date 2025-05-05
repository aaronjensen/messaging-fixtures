require_relative "../../automated_init"

context "Writer Fixture" do
  context "Block" do
    context "No Block Given" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      writer.(message, stream_name)

      fixture = Writer.build(writer, message.class)

      test "Is an error" do
        assert_raises(Writer::Error) do
          fixture.()
        end
      end
    end
  end
end
