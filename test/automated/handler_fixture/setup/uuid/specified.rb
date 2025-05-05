require_relative "../../../automated_init"

context "Handler Fixture" do
  context "Setup" do
    context "UUID" do
      context "Specified" do
        input_message = Controls::Message.example

        uuid = SecureRandom.uuid

        handler = Controls::Handler.example

        fixture = Handler.build(
          handler,
          input_message,
          identifier_uuid: uuid
        )

        identifier = handler.identifier

        test "Handler identifier set to fixture's UUID" do
          assert(identifier.get == uuid)
        end
      end
    end
  end
end
