require "daemons"
require File.join(File.dirname(__FILE__), './../jampel.rb')

Daemons.run_proc('jampel_control') do
  loop do
    jampel = Jampel.new
    loop do
      jampel.update
      sleep(5)
    end
  end
end