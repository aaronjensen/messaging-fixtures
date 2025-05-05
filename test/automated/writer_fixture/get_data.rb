require_relative "../automated_init"

context "Writer Fixture" do
  context "Get Data" do
    context "Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"
      expected_version = 1
      reply_stream_name = "someReplyStream"

      writer.(message, stream_name, expected_version: expected_version, reply_stream_name: reply_stream_name)

      data = Writer.get_data(writer, message.class)

      written_message = data.message
      written_stream_name = data.stream_name
      written_expected_version = data.expected_version
      written_reply_stream_name = data.reply_stream_name

      test "Message" do
        assert(written_message == message)
      end

      test "Stream Name" do
        assert(written_stream_name == stream_name)
      end

      test "Expected Version" do
        assert(written_expected_version == expected_version)
      end

      test "Reply Stream Name" do
        assert(written_reply_stream_name == reply_stream_name)
      end
    end

    context "Written More than Once" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "someStreamName"

      writer.(message, stream_name)
      writer.(message, stream_name)

      test "Is an error" do
        assert_raises(Writer::Error) do
          Writer.get_data(writer, message.class)
        end
      end
    end

    context "Not Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example

      data = Writer.get_data(writer, message.class)

      test "No data" do
        assert(data.nil?)
      end
    end
  end
end
