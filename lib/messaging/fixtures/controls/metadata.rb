module Messaging
  module Fixtures
    module Controls
      module Metadata
        def self.example
          metadata = Messaging::Message::Metadata.new

          metadata.stream_name = stream_name
          metadata.position = position
          metadata.global_position = global_position

          metadata.causation_message_stream_name = causation_message_stream_name
          metadata.causation_message_position = causation_message_position
          metadata.causation_message_global_position = causation_message_global_position

          metadata.correlation_stream_name = correlation_stream_name

          metadata.reply_stream_name = reply_stream_name

          metadata.properties = properties
          metadata.local_properties = local_properties

          metadata.time = time

          metadata.schema_version = schema_version

          metadata
        end

        def self.stream_name
          "example:command-#{Entity.id}"
        end

        def self.position
          1
        end

        def self.global_position
          111
        end

        def self.causation_message_stream_name
          stream_name
        end

        def self.causation_message_position
          position
        end

        def self.causation_message_global_position
          global_position
        end

        def self.correlation_stream_name
          "someCorrelationStream"
        end

        def self.reply_stream_name
          "someReplyStream"
        end

        def self.properties
          {
            :some_property => "some property value"
          }
        end

        def self.local_properties
          {
            :some_local_property => "some local property value"
          }
        end

        def self.local_properties
          {
            some_local_property: "some local property value"
          }
        end

        def self.time
          ::Time.utc(2000, 1, 1, 0, 0, 0, 11)
        end

        def self.schema_version
          "1"
        end
      end
    end
  end
end
