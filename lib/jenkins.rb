class Jenkins
  
    attr_reader :projects, :username, :password
    attr_accessor :overall_build_state, :old_overall_build_state

    def initialize(config = {})
      configure(config)
    end
      
    def configure(config)
      configure_projects(config)
      @username = config["username"]
      @password = config["password"]
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