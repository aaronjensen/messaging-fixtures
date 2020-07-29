require_relative '../automated_init'

context "Written Message" do
  context "Expected Version" do
    context "Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      writer.(message, stream_name)

      fixture = WrittenMessage.build(writer, message)

      fixture.assert_stream_name(stream_name)

      passed = fixture.test_session.test_passed?('Written stream name')

      test "Passed" do
        assert(passed)
      end
    end

    context "Not Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      fixture = WrittenMessage.build(writer, message)

      fixture.assert_stream_name(stream_name)

      passed = fixture.test_session.test_passed?('Written stream name')

      test "Not Passed" do
        refute(passed)
      end
    end
  end
end