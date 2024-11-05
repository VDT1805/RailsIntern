class DemoJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Demo"
  end
end
