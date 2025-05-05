require_relative "../../automated_init"

context "Metadata Fixture" do
  context "Assert Workflow Attributes Assigned" do
    metadata = Controls::Metadata.example

    attribute_names = Messaging::Message::Metadata.workflow_attribute_names

    fixture = Metadata.build(metadata)

    fixture.assert_workflow_attributes_assigned

    attribute_names.each do |attribute_name|
      attribute = attribute_name.to_s

      context attribute do
        passed = fixture.test_session.test_passed?(attribute)

        test "Passed" do
          assert(passed)
        end
      end
    end
  end
end
