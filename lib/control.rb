require "daemons"
require File.expand_path File.join(File.dirname(__FILE__), *%w[.. jampel])

Daemons.run_proc('jampel_control') do
  loop do
    jampel = Jampel.new
    loop do
      jampel.update
      sleep(5)
    end
  end
end