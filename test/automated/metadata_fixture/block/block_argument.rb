require_relative "../../automated_init"

context "Metadata Fixture" do
  context "Block" do
    context "Block Argument" do
      metadata = Controls::Metadata.example

      argument = nil
      fixture = Metadata.build(metadata) do |a|
        argument = a
      end

      fixture.()

      test "Is a Metadata fixture" do
        assert(argument.is_a?(Metadata))
      end
    end
  end
end
