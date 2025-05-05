require_relative "../../automated_init"

context "Metadata Fixture" do
  context "Block" do
    context "No Block Given" do
      metadata = Controls::Metadata.example

      fixture = Metadata.build(metadata)

      test "Is an error" do
        assert_raises(Metadata::Error) do
          fixture.()
        end
      end
    end
  end
end
