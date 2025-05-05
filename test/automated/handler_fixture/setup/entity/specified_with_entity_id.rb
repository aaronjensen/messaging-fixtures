require_relative "../../../automated_init"

context "Handler Fixture" do
  context "Setup" do
    context "Stored Entity" do
      context "Specified" do
        context "Entity ID is Specified" do
          input_message = Controls::Message.example

          entity = Controls::Entity::Identified.example
          entity_id = Identifier::UUID::Random.get

          handler = Controls::Handler.example

          fixture = Handler.build(
            handler,
            input_message,
            entity,
            11,
            entity_id: entity_id
          )

          store = handler.store

          stored_entity, version = store.get(entity_id, include: :version)

          refute(stored_entity.nil?)

          test "Fixture entity is stored in handler's store" do
            assert(stored_entity == entity)
          end

          context "Cache Record" do
            cache_record = store.records[entity_id]

            test "Entity ID is the cache record's ID" do
              assert(cache_record.id == entity_id)
            end
          end
        end
      end
    end
  end
end
