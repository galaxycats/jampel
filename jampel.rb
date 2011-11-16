require 'curb'
require 'yajl'

require 'wirble'
require File.join(File.dirname(__FILE__), './lib/ampel.rb')
require File.join(File.dirname(__FILE__), './lib/jenkins.rb')

class Jampel
  
  attr_reader :jenkins
  
  def initialize
    @jenkins = Jenkins.new(Yajl::Parser.new.parse(File.open(File.join(File.dirname(__FILE__), './config.json'))))
  end
  
  def update
    jenkins.fetch_status
  end
  
end