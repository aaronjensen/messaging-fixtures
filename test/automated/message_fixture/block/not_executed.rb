require_relative "../../automated_init"

context "Message Fixture" do
  context "Block" do
    context "Message Is Nil" do
      message = nil

      effect = nil
      fixture = Message.build(message) do
        effect = :_
      end

      fixture.()

      test "Block is not executed" do
        assert(effect.nil?)
      end

      context_text = "Message"
      context "Context: \"#{context_text}\"" do
        printed = fixture.test_session.context?(context_text)

        test "Printed" do
          assert(printed)
        end
      end

      context "Not nil" do
        failed = fixture.test_session.test_failed?(context_text, "Not nil")

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
