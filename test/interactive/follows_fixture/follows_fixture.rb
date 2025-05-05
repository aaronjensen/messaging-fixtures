require_relative "../interactive_init"

context "Follows Fixture" do
  source_metadata = Controls::Metadata.example
  metadata = Controls::Metadata.example

  metadata.follow(source_metadata)

  fixture(
    Follows,
    metadata,
    source_metadata
  )
end
