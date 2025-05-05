ENV["CONSOLE_DEVICE"] ||= "stdout"
ENV["LOG_LEVEL"] ||= "info"
ENV["LOG_TAGS"] ||= "handle,message,write"

ENV["TEST_BENCH_DETAIL"] ||= ENV["D"] ||= "on"

require_relative "../test_init"

