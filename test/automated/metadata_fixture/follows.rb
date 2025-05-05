require_relative "../automated_init"

context "Metadata Fixture" do
  context "Follows" do
    source_metadata = Controls::Metadata.example
    metadata = Controls::Metadata.example

    metadata.follow(source_metadata)

    fixture = Metadata.build(metadata, source_metadata) {}

    fixture.assert_follows

    passed = fixture.test_session.test_passed?("Follows")

    test "Passed" do
      assert(passed)
    end
  end
end
