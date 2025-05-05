require_relative "../interactive_init"

context "Message Fixture" do
  context "Assert Attributes Assigned" do
    message = Controls::Event.example

    fixture(
      Message,
      message
    ) do |message|

      message.assert_all_attributes_assigned

    end
  end
end
