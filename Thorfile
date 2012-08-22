require "./jampel.rb"

class Server < Thor

  no_tasks do
    def start_process(command)
      exec(command)
    end
  end

  desc "run_in_fg", "start daemon NOT in background"
  def run_in_fg
    start_process('ruby ./lib/control.rb run')
  end
  
  desc "start", "start daemon in background"
  def start
    start_process('ruby ./lib/control.rb start')
  end
  
  desc "stop", "stop background daemon"
  def stop
    start_process('ruby ./lib/control.rb stop')
    Ampel.reset
  end
  
  desc "restart", "restart background daemon"
  def restart
    start_process('ruby ./lib/control.rb restart')
  end

end

class AmpelDevices < Thor
  
  desc "reset", "switch all devices off"
  def reset
    Ampel.reset
  end
  
end
  