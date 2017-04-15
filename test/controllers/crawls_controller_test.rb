require 'test_helper'

class CrawlsControllerTest < ActionController::TestCase
  test "should get search" do
    get :search
    assert_response :success
  end

  test "should get crawl1" do
    get :crawl1
    assert_response :success
  end

  test "should get crawl2" do
    get :crawl2
    assert_response :success
  end

  test "should get crawl3" do
    get :crawl3
    assert_response :success
  end

end
