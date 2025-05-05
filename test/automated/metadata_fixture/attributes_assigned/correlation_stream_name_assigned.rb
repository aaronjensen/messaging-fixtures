require_relative "../../automated_init"

context "Metadata Fixture" do
  context "Assert Correlation Stream Name Assigned" do
    metadata = Controls::Metadata.example

    correlation_stream_name = "someCorrelationStream"
    metadata.correlation_stream_name = correlation_stream_name

    fixture = Metadata.build(metadata)

    fixture.assert_correlation_stream_name_assigned

    context "correlation_stream_name" do
      passed = fixture.test_session.test_passed?("Correlation stream name assigned")

      test "Passed" do
        assert(passed)
      end
    end
  end
end
