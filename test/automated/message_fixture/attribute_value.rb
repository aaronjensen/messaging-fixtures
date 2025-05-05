require_relative "../automated_init"

context "Message Fixture" do
  context "Assert Attribute Value" do
    context "Equal" do
      message = Controls::Message::SomeMessage.example

      value = SecureRandom.hex

      message.some_attribute = value

      fixture = Message.build(message)

      attribute_name = :some_attribute

      fixture.assert_attribute_value(attribute_name, value)

      context "#{attribute_name}" do
        passed = fixture.test_session.test_passed?("#{attribute_name}")

        test "Passed" do
          assert(passed)
        end
      end
    end

    context "Not Equal" do
      message = Controls::Message::SomeMessage.example

      value = SecureRandom.hex

      message.some_attribute = value

      fixture = Message.build(message)

      attribute_name = :some_attribute

      fixture.assert_attribute_value(attribute_name, SecureRandom.hex)

      context "#{attribute_name}" do
        failed = fixture.test_session.test_failed?("#{attribute_name}")

        test "Failed" do
          assert(failed)
        end
      end
    end
  end
end
