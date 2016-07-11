module Nested # :nodoc:
  class Testy < ApplicationRecord # :nodoc:
    def self.build_integer
      Nested::TestyJob.perform_later(5)
    end

    def self.do_this(int)
      logger.warn "int: #{int}"
      p "int: #{int}"
      Nested::Testy.create(num: int)
    end
  end
end
