require_relative '../../../test_helper'

class UserTest < ActiveSupport::TestCase
  test "can log stuff and read stuff" do
    user = User.create
    
    user.log :title => "Hello logger!", :data => {:type => "wee"}
    assert_equal 1, user.logs.length
    
    log = user.logs.first
    
    assert_equal user, log.user
    assert_equal "Hello logger!", log.title
    assert_equal "wee", Psych.load(log.data)[:type]
  end
end
