require_relative "../../automated_init"

context "Handle" do
  context "Input" do
    context "Ignored" do
      handler = Controls::Handler.example

      context "Handler: #{handler.class.name.split("::").last}" do
        detail "Handler Class: #{handler.class.name}"

        input = Controls::Message.example

        entity = Controls::Entity::Identified.example
        detail "Entity Class: #{entity.class.name}"

        sequence = input.metadata.global_position

        entity.sequence = sequence + 1
        detail "Entity Sequence: #{entity.sequence}"

        entity_id = entity.id

        handler.store.add(entity.id, entity)


        context "Input Message: #{input.class.message_type}" do
          detail "Input Message Class: #{input.class}"
          detail "Input Message Sequence: #{sequence}"
        end

        handler.(input)

        writer = handler.write

        output_class = Controls::Event::Output
        context "Output Message: #{output_class.message_type}" do
          detail "Output Message Class: #{output_class}"

          output = writer.one_message do |event|
            event.instance_of?(output_class)
          end

          test "Not written" do
            assert(output.nil?)
          end
        end

        alternate_output_class = Controls::Event::AlternateOutput
        context "#{alternate_output_class.message_type} Alternate Output Message" do
          detail "Output Message Class: #{output_class}"

          alternate_output = writer.one_message do |event|
            event.instance_of?(alternate_output_class)
          end

          test "Not written" do
            assert(alternate_output.nil?)
          end
        end
      end
    end
  end
end
