require_relative "../../interactive_init"

context "Message Fixture" do
  context "Assert Attributes Copied" do
    context "No Source Message" do
      message = Controls::Event.example

      fixture(
        Message,
        message
      ) do |message|

        message.assert_attributes_copied

      end
    end
  end
end
