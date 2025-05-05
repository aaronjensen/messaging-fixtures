require_relative "../interactive_init"

context "Metadata Fixture" do
  source_metadata = Controls::Metadata.example
  metadata = Controls::Metadata.example

  metadata.follow(source_metadata)

  fixture(
    Metadata,
    metadata,
    source_metadata
  ) do |f|

    f.assert_attributes_assigned
    f.assert_source_attributes_assigned
    f.assert_causation_attributes_assigned
    f.assert_workflow_attributes_assigned

    f.assert_correlation_stream_name_assigned
    f.assert_correlation_stream_name(metadata.correlation_stream_name)

    f.assert_reply_stream_name_assigned
    f.assert_reply_stream_name(metadata.reply_stream_name)

    f.assert_follows

  end
end
