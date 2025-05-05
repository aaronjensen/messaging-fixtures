require_relative "../../automated_init"

context "Message Fixture" do
  context "Block" do
    context "Message Is Not Nil" do
      message = Controls::Event.example

      effect = nil
      fixture = Message.build(message) do
        effect = :_
      end

      fixture.()

      test "Block is executed" do
        refute(effect.nil?)
      end
    end
  end
end
