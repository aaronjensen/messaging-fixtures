require_relative "../../automated_init"

context "Controls" do
  context "Entity" do
    context "Alternate" do
      context "Boolean Condition is True" do
        entity = Controls::Entity::Example.new

        entity.alternate_condition = true

        test "Alternate" do
          assert(entity.alternate_condition?)
        end
      end

      context "Boolean Condition is Not True" do
        entity = Controls::Entity::Example.new

        entity.alternate_condition = false

        test "Not alternate" do
          refute(entity.alternate_condition?)
        end
      end
    end
  end
end
