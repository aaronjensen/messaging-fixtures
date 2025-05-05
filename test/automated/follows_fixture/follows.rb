require_relative "../automated_init"

context "Follows Fixture" do
  context "Follows" do
    source_metadata = Controls::Metadata.example
    metadata = Controls::Metadata.example

    metadata.follow(source_metadata)

    fixture = Follows.build(metadata, source_metadata)

    fixture.()

    passed = fixture.test_session.test_passed?("Follows")

    test "Passed" do
      assert(passed)
    end
  end
end
