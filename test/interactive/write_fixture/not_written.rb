require_relative "../interactive_init"

context "Writer Fixture" do
  writer = Messaging::Write::Substitute.build
  stream_name = "someStreamName"
  expected_version = 1
  reply_stream_name = "someReplyStream"

  message_class = Controls::Message::Random.example_class

  fixture(
    Writer,
    writer,
    message_class
  ) do |written_message|

    written_message.assert_stream_name(stream_name)
    written_message.assert_expected_version(expected_version)
    written_message.assert_reply_stream_name(reply_stream_name)

  end
end
