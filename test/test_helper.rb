ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
require 'test_help'
require 'controllers/selenium_controller'

module SeleniumOnRails::Paths
  def selenium_tests_path
    File.expand_path(File.dirname(__FILE__) + '/../test_data')
  end
end

class SeleniumController
  attr_accessor :layout_override
  # Re-raise errors caught by the controller.
  def rescue_action e
    raise e
  end
      
  def render options = nil, deprecated_status = nil
    if override_layout? options
      options[:layout] = false
      super options, deprecated_status
      return response.body = @layout_override.gsub('@content_for_layout', response.body)
    end
    super options, deprecated_status
  end
  
  private
    def override_layout? options
      return false unless @layout_override
      if options[:action] or options[:template]
        options[:layout] != false #for action and template the default layout is used if not explicitly disabled
      else
        not [nil, false].include? options[:layout] #otherwise a layout has to be specified
      end
    end

end

class Test::Unit::TestCase
  def assert_text_equal expected, actual
    assert_equal clean_text(expected), clean_text(actual)
  end
  
  def clean_text text
    text.gsub("\t", '  ').gsub("\r\n", "\n")
  end
  
end
