require_relative "../../automated_init"

context "Writer Fixture" do
  context "Block" do
    context "Message Is Not Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      effect = nil
      fixture = fixture = Writer.build(writer, message.class) do
        effect = :_
      end

      fixture.()

      test "Block is not executed" do
        assert(effect.nil?)
      end

      context_text = "Write: #{message.class.message_type}"
      context "Context: \"#{context_text}\"" do
        printed = fixture.test_session.context?(context_text)

        test "Printed" do
          assert(printed)
        end
      end

      context "Written" do
        failed = fixture.test_session.test_failed?(context_text, "Written")

        test "Failed" do
          assert(failed)
        end
      end

      context "Skipped Tests Detail Notice" do
        printed = fixture.test_session.detail?(context_text, "Remaining message tests are skipped")

        test "Printed" do
          assert(printed)
        end
      end
    end
  end
end
