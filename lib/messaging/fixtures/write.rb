module Messaging
  module Fixtures
    class Write
      Error = Class.new(RuntimeError)

      include TestBench::Fixture
      include Initializer

      initializer :message, :stream_name, :expected_version, :reply_stream_name, :action

      def self.build(writer, message_class, &action)
        data = get_data(writer, message_class)

        message = data&.message
        stream_name = data&.stream_name
        expected_version = data&.expected_version
        reply_stream_name = data&.reply_stream_name

        new(message, stream_name, expected_version, reply_stream_name, action)
      end

      def self.get_data(writer, message_class)
        sink = writer.sink

        records = sink.written_records.select do |record|
          record.data.message.class == message_class
        end

        if records.length > 1
          raise Error, "More than one message written (Message Class: #{message_class})"
        end

        if records.empty?
          return nil
        end

        records.first.data
      end

      def call
        message_class = message&.class

        context_name = 'Write'
        if not message_class.nil?
          context_name = "#{context_name}: #{message_class&.message_type}"
        end

        context context_name do
          if action.nil?
            raise Error, "Write fixture must be executed with a block"
          end

          detail "Message Class: #{message_class.inspect}"

          written = !message.nil?

          test "Written" do
            if not action.nil?
              detail "Remaining message tests are skipped"
            end

            assert(written)
          end

          return if !written

          action.call(self)
        end

        message
      end

      def assert_stream_name(stream_name)
        test "Stream name" do
          detail "Stream Name: #{stream_name}"
          detail "Written Stream Name: #{self.stream_name}"

          assert(stream_name == self.stream_name)
        end
      end

      def assert_expected_version(expected_version)
        test "Expected version" do
          detail "Expected Version: #{expected_version}"
          detail "Written Expected Version: #{self.expected_version}"

          assert(expected_version == self.expected_version)
        end
      end

      def assert_reply_stream_name(reply_stream_name)
        test "Reply stream name" do
          detail "Reply stream Name: #{reply_stream_name}"
          detail "Written reply stream Name: #{self.reply_stream_name}"

          assert(reply_stream_name == self.reply_stream_name)
        end
      end
    end
  end
end
