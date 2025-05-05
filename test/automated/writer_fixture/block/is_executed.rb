require_relative "../../automated_init"

context "Writer Fixture" do
  context "Block" do
    context "Is Executed" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      writer.(message, stream_name)

      effect = nil
      fixture = Writer.build(writer, message.class) do
        effect = :_
      end

      fixture.()

      test "Block is executed" do
        refute(effect.nil?)
      end
    end
  end
end
