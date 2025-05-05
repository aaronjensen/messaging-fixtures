require_relative "../automated_init"

context "Writer Fixture" do
  context "Assert Stream Name" do
    context "Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      writer.(message, stream_name)

      fixture = Writer.build(writer, message.class)

      fixture.assert_stream_name(stream_name)

      passed = fixture.test_session.test_passed?("Stream name")

      test "Passed" do
        assert(passed)
      end
    end

    context "Not Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      writer.(message, SecureRandom.hex)

      fixture = Writer.build(writer, message.class)

      fixture.assert_stream_name(stream_name)

      failed = fixture.test_session.test_failed?("Stream name")

      test "Failed" do
        assert(failed)
      end
    end
  end
end
