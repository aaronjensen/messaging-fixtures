require_relative "../automated_init"

context "Message Fixture" do
  context "Assert Attributes Assigned" do
    message = Controls::Event.example
    message_class = message.class

    attribute_names = message_class.attribute_names

    fixture = Message.build(message)

    fixture.assert_attributes_assigned(attribute_names)

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
