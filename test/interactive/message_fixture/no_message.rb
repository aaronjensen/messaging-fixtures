require_relative "../interactive_init"

context "Message Fixture" do
  context "No Message" do
    message = nil

    fixture(
      Message,
      message
    ) do |message|

      fail "Block will not be executed"

    end
  end
end
