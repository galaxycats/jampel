class Ampel
  
  AVAILABLE_DEVICES = %w[0A 1A 1B 1D]
  
  class <<self
    
    def green_on
      green(:on)
      yellow(:off)
      red(:off)
    end

    def yellow_on
      yellow(:on)
    end
    
    def red_on
      green(:off)
      yellow(:off)
      red(:on)
      alarm(:on)
      sleep(5)
      alarm(:off)
    end
    
    def reset
      AVAILABLE_DEVICES.each do |device|
        switch(device, "off")
      end
    end
    
    def green(on_or_off)
      switch("0A", on_or_off.to_s)
    end
    
    def yellow(on_or_off)
      switch("1B", on_or_off.to_s)
    end
    
    def red(on_or_off)
      switch("1A", on_or_off.to_s)
    end
    
    def alarm(on_or_off)
      switch("1D", on_or_off.to_s)
    end
    
    def switch(device, call)
      Curl::Easy.new("http://192.168.0.232/ecmd?$#{device}-#{call}").perform
    end
    
  end
  
end