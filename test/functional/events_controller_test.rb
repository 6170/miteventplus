require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end
  
  test "should get resources" do
    get :resources
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  #test "should create event" do
	#assert_difference('Event.count') do
		#get :create, :event => { :title => 'CHRISTMAS' }
	#end
  #end
  
  #test "create should create timeblock" do
    #get :create, :event => { :title => 'NYE' }
    #assert_not_nil(:event.timeblock)
  #end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

end
