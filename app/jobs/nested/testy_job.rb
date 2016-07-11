module Nested # :nodoc:
  class TestyJob < ApplicationJob # :nodoc:
    def perform(int)
      Nested::Testy.do_this(int)
    end
  end
end
