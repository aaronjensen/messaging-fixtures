require_relative "../../automated_init"

context "Controls" do
  context "Entity" do
    context "Processed" do
      sequence = Controls::Sequence.example

      context "Has not yet processed" do
        context "Entity's sequence is lower than the sequence" do
          example = Controls::Entity.example(sequence: sequence - 1)

          processed = example.processed?(sequence)

          test do
            refute(processed)
          end
        end

        context "Entity's sequence is nil" do
          example = Controls::Entity.example
          example.sequence = nil

          processed = example.processed?(sequence)

          test do
            refute(processed)
          end
        end
      end

      context "Has processed" do
        context "Entity's sequence is greater than the sequence" do
          example = Controls::Entity.example(sequence: sequence + 1)

          processed = example.processed?(sequence)

          test do
            assert(processed)
          end
        end

        context "Entity's sequence is equal to the sequence" do
          example = Controls::Entity.example(sequence: sequence)

          processed = example.processed?(sequence)

          test do
            assert(processed)
          end
        end
      end
    end
  end
end
