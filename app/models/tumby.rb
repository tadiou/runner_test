class Tumby < ApplicationRecord # :nodoc:
  def self.build_integer
    TumbyJob.perform_later(5)
  end

  def self.do_this(int)
    logger.warn "int: #{int}"
    p "int: #{int}"
    Tumby.create(num: int)
  end
end
