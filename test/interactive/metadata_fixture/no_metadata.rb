require_relative "../interactive_init"

context "Metadata Fixture" do
  context "No Metadata" do
    metadata = nil

    fixture(
      Metadata,
      metadata
    ) do |f|

      fail "Block will not be executed"

    end
  end
end
