require_relative "../../automated_init"

context "Metadata Fixture" do
  context "Assert Reply Stream Name" do
    metadata = Controls::Metadata.example

    reply_stream_name = "someReplyStream"
    metadata.reply_stream_name = reply_stream_name

    fixture = Metadata.build(metadata)

    fixture.assert_reply_stream_name(reply_stream_name)

    context "reply_stream_name" do
      passed = fixture.test_session.test_passed?("reply_stream_name")

      test "Passed" do
        assert(passed)
      end
    end
  end
end
