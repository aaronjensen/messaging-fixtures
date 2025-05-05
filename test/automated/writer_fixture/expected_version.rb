require_relative "../automated_init"

context "Writer Fixture" do
  context "Assert Expected Version" do
    context "Write" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      writer.(message, stream_name, expected_version: 11)

      fixture = Writer.build(writer, message.class)

      fixture.assert_expected_version(11)

      passed = fixture.test_session.test_passed?("Expected version")

      test "Passed" do
        assert(passed)
      end
    end

    context "Not Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      writer.(message, stream_name, expected_version: 111)

      fixture = Writer.build(writer, message.class)

      fixture.assert_expected_version(11)

      failed = fixture.test_session.test_failed?("Expected version")

      test "Failed" do
        assert(failed)
      end
    end
  end
end
