require_relative "test/test_init"

class SomeMessage
  include Messaging::Message

  attribute :something_id, String
  attribute :amount, Integer
  attribute :time, String
end

class SomeEvent
  include Messaging::Message

  attribute :something_id, String
  attribute :quantity, Integer
  attribute :time, String
  attribute :processed_time, String
end

class SomeOtherEvent
  include Messaging::Message
end

class Something
  include Schema::DataStructure

  LIMIT = 100

  attribute :id, String
  attribute :total, Integer, default: -> { 0 }

  def accumulate(quantity)
    self.total += quantity
  end

  def limit?(quantity)
    (quantity + total) >= LIMIT
  end
end

class SomeProjection
  include ::EntityProjection

  entity_name :something

  apply SomeEvent do |some_event|
    something.id = some_event.something_id
    something.accumulate(some_event.quantity)
  end
end

module Reader
  class Noop
    include MessageStore::Read
  end
end

class SomeStore
  include EntityStore

  category :something
  entity Something
  projection SomeProjection
  reader Reader::Noop
end

class SomeHandler
  include Messaging::Handle
  include Log::Dependency
  include Messaging::StreamName

  dependency :clock, Clock::UTC
  dependency :store, SomeStore
  dependency :write, Messaging::Write

  handle SomeMessage do |some_message|
    something_id = some_message.something_id

    something, version = store.fetch(something_id, include: :version)

    if something.limit?(some_message.amount)
      logger.info(tag: :ignored) { "Message ignored: limit reached (Quantity: #{something.quantity}, Amount: #{some_message.amount}, Limit: #{Something.LIMIT})" }
      return
    end

    attributes = [
      :something_id,
      { :amount => :quantity },
      :time,
    ]

    time = clock.iso8601

    some_event = SomeEvent.follow(some_message, copy: attributes)

    some_event.processed_time = time

    some_event.metadata.correlation_stream_name = "someCorrelationStream"
    some_event.metadata.reply_stream_name = "someReplyStream"

    stream_name = stream_name(something_id, category: "something")

    write.(some_event, stream_name, expected_version: version)
  end
end

context "Handle SomeMessage" do
  effective_time = Clock::UTC.now
  processed_time = effective_time + 1

  something_id = SecureRandom.uuid

  message = SomeMessage.new
  message.something_id = something_id
  message.amount = 1
  message.time = Clock.iso8601(effective_time)

  message.metadata.stream_name = "something:command-#{something_id}"
  message.metadata.position = 11
  message.metadata.global_position = 111

  something = Something.new
  something.id = something_id
  something.total = 98

  entity_version = 1111

  event_class = SomeEvent
  output_stream_name = "something-#{something_id}"

  handler = SomeHandler.new

  fixture(
    Handler,
    handler,
    message,
    something,
    entity_version,
    clock_time: processed_time
  ) do |handler|

    handler.assert_input_message do |message|
      message.assert_attributes_assigned

      message.assert_metadata do |metadata|
        metadata.assert_source_attributes_assigned
      end
    end

    event = handler.assert_write(event_class) do |write|
      write.assert_stream_name(output_stream_name)
      write.assert_expected_version(entity_version)
    end

    handler.assert_written_message(event) do |written_message|
      written_message.assert_follows

      written_message.assert_attributes_copied([
        :something_id,
        { :amount => :quantity },
        :time,
      ])

      written_message.assert_attribute_value(:processed_time, Clock.iso8601(processed_time))

      written_message.assert_attributes_assigned

      written_message.assert_metadata do |metadata|
        metadata.assert_correlation_stream_name("someCorrelationStream")
        metadata.assert_reply_stream_name("someReplyStream")
      end
    end

    handler.refute_write(SomeOtherEvent)
  end
end
