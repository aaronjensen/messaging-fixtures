require_relative "../automated_init"

context "Writer Fixture" do
  context "Assert Reply Stream Name" do
    context "Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"
      reply_stream_name = "someReplyStream"

      writer.(message, stream_name, reply_stream_name: reply_stream_name)

      fixture = Writer.build(writer, message.class)

      fixture.assert_reply_stream_name(reply_stream_name)

      passed = fixture.test_session.test_passed?("Reply stream name")

      test "Passed" do
        assert(passed)
      end
    end

    context "Not Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"
      reply_stream_name = "someReplyStream"

      writer.(message, stream_name, reply_stream_name: SecureRandom.hex)

      fixture = Writer.build(writer, message.class)

      fixture.assert_reply_stream_name(reply_stream_name)

      failed = fixture.test_session.test_failed?("Reply stream name")

      test "Failed" do
        assert(failed)
      end
    end
  end
end
