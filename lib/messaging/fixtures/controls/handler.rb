module Messaging
  module Fixtures
    module Controls
      module Handler
        def self.example
          Example.new
        end

        def self.noop
          Noop.new
        end

        class Example
          include Messaging::Handle
          include Log::Dependency
          include Messaging::StreamName

          dependency :store, Controls::Store::Example
          dependency :write, Messaging::Write
          dependency :clock, Clock::UTC
          dependency :identifier, Identifier::UUID::Random

          category :example

          handle Controls::Message::Input do |input|
            example_id = input.example_id

            example, version = store.fetch(example_id, include: :version)

            sequence = input.metadata.global_position

            if example.processed?(sequence)
              logger.info(tag: :ignored) { "Input message ignored (Message: #{input.message_type}, Example ID: #{example_id}, Message Sequence: #{sequence}, Entity Sequence: #{example.sequence})" }
              return
            end

            time = clock.iso8601
            stream_name = stream_name(example_id)

            attributes = [
              :example_id,
              { :quantity => :amount },
              :time,
            ]

            if example.alternate_condition?
              alternate_output = Controls::Event::AlternateOutput.follow(input, copy: attributes)

              alternate_output.processed_time = time
              alternate_output.sequence = sequence

              alternate_output.metadata.correlation_stream_name = "someCorrelationStream"
              alternate_output.metadata.reply_stream_name = "someReplyStream"

              write.(alternate_output, stream_name, expected_version: version)

              return
            end

            output = Controls::Event::Output.follow(input, copy: attributes)

            output.processed_time = time
            output.sequence = sequence

            output.metadata.correlation_stream_name = "someCorrelationStream"
            output.metadata.reply_stream_name = "someReplyStream"

            write.(output, stream_name, expected_version: version)
          end
        end

        class Noop
          include Messaging::Handle

          def handle(*)
          end
        end
      end
    end
  end
end
