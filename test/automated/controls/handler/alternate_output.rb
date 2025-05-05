require_relative "../../automated_init"

context "Handle" do
  context "Input" do
    handler = Controls::Handler.example

    context "Handler: #{handler.class.name.split("::").last}" do
      detail "Handler Class: #{handler.class.name}"

      input = Controls::Message.example

      clock_time = Controls::Time::Processed::Raw.example

      handler.clock.now = clock_time

      entity = Controls::Entity::Identified.example
      detail "Entity Class: #{entity.class.name}"

      entity.alternate_condition = true
      assert(entity.alternate_condition?)

      sequence = input.metadata.global_position

      entity.sequence = sequence - 1
      detail "Entity Sequence: #{entity.sequence}"

      entity_id = entity.id

      entity_version = 11

      handler.store.add(entity.id, entity, entity_version)


      attribute_names = [
        :example_id,
        :quantity,
        :time
      ]

      context "Input Message: #{input.class.message_type}" do
        detail "Input Message Class: #{input.class}"
        detail "Input Message Sequence: #{sequence}"

        context "Preconditions" do
          fixture(
            Schema::Fixtures::Assignment,
            input,
            attribute_names,
            print_title_context: false,
            attributes_context_name: "Message"
          )

          metadata_attribute_names = [
            :stream_name,
            :position,
            :global_position
          ]

          fixture(
            Schema::Fixtures::Assignment,
            input.metadata,
            metadata_attribute_names,
            print_title_context: false,
            attributes_context_name: "Metadata"
          )
        end
      end

      handler.(input)

      writer = handler.write

      output_category = "example"

      output_class = Controls::Event::AlternateOutput
      context "Output Message: #{output_class.message_type}" do
        detail "Output Message Class: #{output_class}"

        output = writer.one_message do |event|
          event.instance_of?(output_class)
        end

        if output.nil?
          test "Written" do
            assert(false)
          end
        else
          output_stream_name = "#{output_category}-#{entity_id}"

          written_to_stream = writer.written?(output) do |stream_name|
            stream_name == output_stream_name
          end

          test "Written to output stream" do
            detail "Output Stream Name: #{output_stream_name}"
            refute(output.nil?)
            assert(written_to_stream)
          end


          test "Output follows input" do
            detail "Input Stream Name: #{input.metadata.stream_name.inspect}"
            detail "Output Causation Stream Name: #{output.metadata.causation_message_stream_name.inspect}"

            detail "Input Position: #{input.metadata.position.inspect}"
            detail "Output Causation Position: #{output.metadata.causation_message_position.inspect}"

            detail "Input Global Position: #{input.metadata.global_position.inspect}"
            detail "Output Causation Global Position: #{output.metadata.causation_message_global_position.inspect}"

            detail "Input Reply Stream Name: #{input.metadata.reply_stream_name.inspect}"
            detail "Output Reply Stream Name: #{output.metadata.reply_stream_name.inspect}"

            assert(output.follows?(input))
          end


          context "Expected Version" do
            test "Written with expected version" do
              written_with_expected_version = writer.written?(output) do |_, expected_version|
                !expected_version.nil?
              end

              assert(written_with_expected_version)
            end

            test "Expected version is entity version" do
              expected_version_is_entity_version = writer.written?(output) do |_, expected_version|
                detail "Entity Version: #{entity_version}"
                detail "Expected Version: #{expected_version}"

                expected_version == entity_version
              end

              assert(expected_version_is_entity_version)
            end
          end


          copied_attribute_names = [
            :example_id,
            { :quantity => :amount },
            :time,
          ]

          context "Attributes" do
            fixture(
              Schema::Fixtures::Equality,
              input,
              output,
              copied_attribute_names,
              ignore_class: true,
              print_title_context: false,
              attributes_context_name: "Copied"
            )

            context "Assigned" do
              test "processed_time" do
                clock_time_iso8601 = Clock::UTC.iso8601(clock_time)

                detail "Clock Time: #{clock_time_iso8601}"
                detail "Processed Time: #{output.processed_time}"

                assert(output.processed_time == clock_time_iso8601)
              end

              test "sequence" do
                detail "Input Sequence: #{sequence}"
                detail "Output Sequence: #{output.sequence}"

                assert(output.sequence == sequence)
              end
            end
          end

          context "Metadata" do
            context "Assigned" do
              { correlation_stream_name: "someCorrelationStream", reply_stream_name: "someReplyStream" }.each do |name, value|
                context do
                  metadata_value = output.metadata.public_send(name)
                  compare_value = value

                  test "#{name}" do
                    detail "Metadata Vale: #{metadata_value.inspect}"
                    detail "Compare Value: #{compare_value.inspect}"

                    assert(metadata_value == compare_value)
                  end
                end
              end
            end
          end
        end

        context "Final Inspection" do
          changed_attribute_names = [
            :example_id,
            :amount,
            :time,
            :processed_time,
            :sequence
          ]

          fixture(
            Schema::Fixtures::Assignment,
            output,
            changed_attribute_names,
            print_title_context: false,
            attributes_context_name: "Attributes Have Been Set"
          )
        end
      end

      alternate_output_class = Controls::Event::Output
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
