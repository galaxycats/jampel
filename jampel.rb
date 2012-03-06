require 'curb'
require 'yajl'

require 'wirble'
require File.join(File.dirname(__FILE__), './lib/ampel.rb')
require File.join(File.dirname(__FILE__), './lib/jenkins.rb')

class Jampel
  
  attr_reader :jenkins
  
  def initialize
    config_path = File.expand_path('~/.jampel_config.json')
    @jenkins = Jenkins.new(Yajl::Parser.new.parse(File.open(config_path)))
  end
  
  def update
    jenkins.fetch_status
  end
  
end