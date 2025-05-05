require_relative "../automated_init"

context "Follows Fixture" do
  context "No Metadata" do
    metadata = nil

    fixture = Follows.build(metadata)

    fixture.()

    failed = fixture.test_session.test_failed?("Metadata not nil")

    test "Failed" do
      assert(failed)
    end
  end
end
