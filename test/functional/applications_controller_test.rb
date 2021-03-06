require 'test_helper'

# These tests are run using the fake CAS user 'casuser'
class ApplicationsControllerTest < ActionController::TestCase
  setup do
    CASClient::Frameworks::Rails::Filter.fake("casuser")
  end

  test "valid cas user with no roles should get denied" do
    Authorization.current_user.roles.delete_all # ensure they have no roles
    puts Authorization.current_user.role_symbols
    assert Authorization.current_user.role_symbols.length == 0, "current_user should not have had any roles for this test"
    get :index
    assert_redirected_to(:controller => "site", :action => "access_denied")
  end

  test "valid cas user with access role should get index" do
    grant_test_user_basic_access

    get :index

    assert_response :success
    assert_not_nil assigns(:applications)
  end

  test "JSON request should include certain attributes" do
    grant_test_user_admin_access

    get :show, :format => :json, :id => '1'

    body = JSON.parse(response.body)

    assert body.include?('id'), 'JSON response does not include id field'
    assert body.include?('name'), 'JSON response does not include name field'
    assert body.include?('description'), 'JSON response does not include description field'
    assert body.include?('roles'), 'JSON response should include roles'
    
    # body['roles'] should include entities which include name and id (for frontend interface role assignment, applicaiton saving, and new role creation saving (temp ID -> real ID), etc.)
    body['roles'].each do |r|
      assert r["id"], "JSON response's 'roles' section should include an ID field"
      assert r["name"], "JSON response's 'roles' section should include a name field"
      assert r["token"], "JSON response's 'roles' section should include a token field"
      assert r["description"], "JSON response's 'roles' section should include a description field"
      # ad_path may be nil so check for existence not value
      assert r.has_key?("ad_path"), "JSON response's 'roles' section should include an ad_path field"
    end

    assert body["owners"], "JSON response should include an 'owners' section"
    body["owners"].each do |o|
      assert o["id"], "JSON response's 'owners' section's 'members' should include an ID"
      assert o["name"], "JSON response's 'owners' section's 'members' should include a name"
    end

    assert body["operatorships"], "JSON response should include an 'operatorships' section"    
    body["operatorships"].each do |o|
      assert o["id"], "JSON response's 'operatorships' section should include an ID"
      assert o["name"], "JSON response's 'operatorships' section should include a name"
    end
  end
end
