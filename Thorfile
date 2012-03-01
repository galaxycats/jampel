require "./jampel.rb"

class Server < Thor

  desc "run", "start daemon NOT in background"
  def run
    `ruby ./lib/control.rb run`
  end
  
  desc "start", "start daemon in background"
  def start
    `ruby ./lib/control.rb start`
  end
  
  desc "stop", "stop background daemon"
  def stop
    `ruby ./lib/control.rb stop`
  end
  
  desc "restart", "restart background daemon"
  def restart
    `ruby ./lib/control.rb restart`
  end

end

class AmpelDevices < Thor
  
  desc "reset", "switch all devices off"
  def reset
    Ampel.reset
  end
  
end
  