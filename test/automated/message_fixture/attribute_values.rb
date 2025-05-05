require_relative "../automated_init"

context "Message Fixture" do
  context "Assert Attribute Values" do
    context "All Equal" do
      message = Controls::Message::SomeMessage.example

      some_attribute_value = SecureRandom.hex
      some_other_attribute_value = SecureRandom.hex

      message.some_attribute = some_attribute_value
      message.some_other_attribute = some_other_attribute_value

      attributes = {
        some_attribute: some_attribute_value,
        some_other_attribute: some_other_attribute_value
      }

      fixture = Message.build(message)

      fixture.assert_attribute_values(attributes)

      attributes.keys.each do |attribute_name|
        context "#{attribute_name}" do
          passed = fixture.test_session.test_passed?("#{attribute_name}")

          test "Passed" do
            assert(passed)
          end
        end
      end
    end

    context "None Equal" do
      message = Controls::Message::SomeMessage.example

      some_attribute_value = SecureRandom.hex
      some_other_attribute_value = SecureRandom.hex

      message.some_attribute = some_attribute_value
      message.some_other_attribute = some_other_attribute_value

      attributes = {
        some_attribute: SecureRandom.hex,
        some_other_attribute: SecureRandom.hex
      }

      fixture = Message.build(message)

      fixture.assert_attribute_values(attributes)

      attributes.keys.each do |attribute_name|
        context "#{attribute_name}" do
          passed = fixture.test_session.test_passed?("#{attribute_name}")

          test "Failed" do
            refute(passed)
          end
        end
      end
    end

    context "Some Equal" do
      message = Controls::Message::SomeMessage.example

      some_attribute_value = SecureRandom.hex
      some_other_attribute_value = SecureRandom.hex

      message.some_attribute = some_attribute_value
      message.some_other_attribute = some_other_attribute_value

      attribute_values = {
        some_attribute: some_attribute_value,
        some_other_attribute: SecureRandom.hex
      }

      fixture = Message.build(message)

      fixture.assert_attribute_values(attribute_values)

      context "some_attribute" do
        passed = fixture.test_session.test_passed?("some_attribute")

        test "Passed" do
          assert(passed)
        end
      end

      context "some_other_attribute" do
        passed = fixture.test_session.test_passed?("some_other_attribute")

        test "Failed" do
          refute(passed)
        end
      end
    end
  end
end
