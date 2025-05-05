require_relative "../interactive_init"

context "Follows Fixture" do
  context "No Source Metadata" do
    source_metadata = nil
    metadata = Controls::Metadata.example

    fixture(
      Follows,
      metadata,
      source_metadata
    )
  end
end
