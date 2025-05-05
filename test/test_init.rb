puts RUBY_DESCRIPTION

ENV["TEST_BENCH_DETAIL"] ||= ENV["D"]

puts
puts "TEST_BENCH_DETAIL: #{ENV["TEST_BENCH_DETAIL"].inspect}"
puts

require_relative "../init.rb"
require "messaging/fixtures/controls"

require "pp"

require "test_bench"; TestBench.activate

include Messaging::Fixtures
