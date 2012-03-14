class Jenkins
  
  class BuildState
    attr_accessor :api_response
    
    def initialize(api_response)
      @api_response = api_response
    end
    
    def build_state
      self.api_response ? (building? ? "BUILDING" : build_result) : ""
    end
    
    def build_result
      self.api_response["result"]
    end
    
    def building?
      !!self.api_response["building"]
    end
    
    def success?
      build_result == "SUCCESS"
    end
    
    def failed?
      build_result == "FAILURE"
    end
    
    def ==(other)
      build_state == other.build_state
    end
    
  end
  
  attr_reader :url, :username, :password
  attr_accessor :api_response, :build_state, :old_build_state
  
  def initialize(config = {})
    configure(config)
  end
  
  def fetch_status
    perform_request
    update_state
    execute_callbacks
  end
  
  private

    def configure(config)
      @url      = config["url"]
      @username = config["username"]
      @password = config["password"]
    end
    
    def perform_request
      request = prepare_request
      begin
        request.perform
        if request.response_code == 200
          self.api_response = Yajl::Parser.new.parse(request.body_str)
        else
          raise "API Request failed: #{request.response_code}"
        end
      rescue Curl::Err => e
        # The net is not reliable, so just swallow all request related errors and try it again
        puts e.to_s
      end
    end
    
    def prepare_request
      curl = Curl::Easy.new(url)
      curl.username = self.username
      curl.password = self.password
      curl
    end
    
    def update_state
      self.old_build_state = build_state
      self.build_state = BuildState.new(api_response)
    end
    
    def execute_callbacks
      if old_build_state && build_state == old_build_state
        nothing_changed_callback
      else
        if build_state.success?
          success_callback
        elsif build_state.failed?
          failed_callback
        elsif build_state.building?
          building_callback
        end
      end
    end
    
    def success_callback
      puts "SUCCESS"
      Ampel.green_on
    end
    
    def failed_callback
      puts "FAILED"
      Ampel.red_on
    end
    
    def building_callback
      Ampel.yellow_on
    end
    
    def nothing_changed_callback
      puts "nothing changed"
    end
  
  
end