require_relative "../automated_init"

context "Follows Fixture" do
  context "No Source Metadata" do
    source_metadata = nil
    metadata = Controls::Metadata.example

    fixture = Follows.build(metadata, source_metadata)

    fixture.()

    failed = fixture.test_session.test_failed?("Source metadata not nil")

    test "Failed" do
      assert(failed)
    end
  end
end
