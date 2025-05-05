require_relative "../automated_init"

context "Writer Fixture" do
  context "Not Written" do
    writer = Messaging::Write::Substitute.build
    stream_name = "someStreamName"

    message_class = Controls::Message::Random.example_class

    fixture = Writer.build(writer, message_class) {}

    fixture.()

    failed = fixture.test_session.test_failed?("Written")

    test "Failed" do
      assert(failed)
    end
  end
end
