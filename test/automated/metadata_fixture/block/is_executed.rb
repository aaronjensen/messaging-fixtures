require_relative "../../automated_init"

context "Metadata Fixture" do
  context "Block" do
    context "Block Argument" do
      metadata = Controls::Metadata.example

      effect = nil
      fixture = Metadata.build(metadata) do
        effect = :_
      end

      fixture.()

      test "Block is executed" do
        refute(effect.nil?)
      end
    end
  end
end
