require_relative "../interactive_init"

context "Follows Fixture" do
  context "No Metadata" do
    metadata = nil

    fixture(
      Follows,
      metadata
    )
  end
end
