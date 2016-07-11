class TumbyJob < ApplicationJob # :nodoc:
  def perform(int)
    Tumby.do_this(int)
  end
end
