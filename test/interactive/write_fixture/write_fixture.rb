require_relative "../interactive_init"

context "Writer Fixture" do
  writer = Messaging::Write::Substitute.build
  message = Controls::Event.example
  stream_name = "example-#{message.example_id}"
  expected_version = 1
  reply_stream_name = "someReplyStream"

  writer.(message, stream_name, expected_version: expected_version, reply_stream_name: reply_stream_name)

  message_class = message.class

  fixture(
    Writer,
    writer,
    message.class
  ) do |written_message|

    written_message.assert_stream_name(stream_name)
    written_message.assert_expected_version(expected_version)
    written_message.assert_reply_stream_name(reply_stream_name)

  end
end
