require_relative "../../automated_init"

context "Metadata Fixture" do
  context "Assert Reply Stream Name Assigned" do
    metadata = Controls::Metadata.example

    reply_stream_name = "someReplyStream"
    metadata.reply_stream_name = reply_stream_name

    fixture = Metadata.build(metadata)

    fixture.assert_reply_stream_name_assigned

    context "reply_stream_name" do
      passed = fixture.test_session.test_passed?("Reply stream name assigned")

      test "Passed" do
        assert(passed)
      end
    end
  end
end
