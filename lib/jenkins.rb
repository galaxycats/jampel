class Jenkins
  
  
  
  class Project
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

      def <=>(other)
        build_state <=> other.build_state
      end
      
    end


    attr_reader :project_url, :username, :password, :jenkins
    attr_accessor :api_response, :build_state, :old_build_state

    def initialize(jenkins, project_url)
      @jenkins     = jenkins
      @project_url = project_url
    end
    
    def fetch_status
      perform_request
      update_state
    end

    def <=>(other)
      build_state <=> other.build_state
    end

    def failed?
      build_state.failed?
    end

    def success?
      build_state.success?
    end

    def building?
      build_state.building?
    end

    private
      
      def perform_request
        request = prepare_request
        begin
          request.perform
          if request.response_code == 200
            self.api_response = Yajl::Parser.new.parse(request.body_str)
          else
            raise "API Request failed: #{request.response_code}"
          end
        rescue Curl::Err::HostResolutionError, Curl::Err::ConnectionFailedError => e
          # The net is not reliable, so just swallow all request related errors and try it again
          puts e.to_s
        end
      end
      
      def prepare_request
        curl = Curl::Easy.new(project_url)
        curl.username = jenkins.username
        curl.password = jenkins.password
        curl
      end

      def update_state
        self.old_build_state = build_state
        self.build_state = BuildState.new(api_response)
      end
      
  end
  
    attr_reader :projects, :username, :password
    attr_accessor :overall_build_state, :old_overall_build_state

    def initialize(config = {})
      configure(config)
    end
      
    def configure(config)
      configure_projects(config)
      @username = config.fetch("username")
      @password = config.fetch("password")
    end

    def configure_projects(config)
      @projects ||= []
      config.fetch("projects").each do |project_url|
        @projects << Project.new(self, project_url)
      end
    end

    def fetch_status
      update_projects
      execute_callbacks
    end
    
    def update_projects
      projects.each(&:fetch_status)
      self.old_overall_build_state = overall_build_state
      self.overall_build_state = projects.map(&:build_state).uniq.sort
    end
    
    def execute_callbacks
      if nothing_changed?
        nothing_changed_callback
      else
        if all_project_successful?
          success_callback
        elsif any_project_failed?
          failed_callback
        elsif any_project_building?
          building_callback
        end
      end
    end

    def nothing_changed?
      old_overall_build_state && overall_build_state == old_overall_build_state
    end

    def all_project_successful?
      projects.all?(&:success?)
    end

    def any_project_failed?
      projects.any?(&:failed?)
    end

    def any_project_building?
      projects.any?(&:building?)
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