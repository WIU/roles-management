require 'test_helper'

# These tests are run using the fake CAS user 'casuser'
class EntitiesControllerTest < ActionController::TestCase
  setup do
    CASClient::Frameworks::Rails::Filter.fake("casuser")
    
    @person = entities(:casuser)
    @group = entities(:groupA)
  end

  test 'JSON show request for a Group should include certain attributes' do
    grant_test_user_admin_access

    get :show, :format => :json, :id => @group.id

    body = JSON.parse(response.body)
    
    assert body.include?('id'), 'JSON response should include id field'
    assert body.include?('name'), 'JSON response should include name field'
    assert body.include?('description'), 'JSON response should include description field'
    assert body.include?('type'), 'JSON response should include type field'

    assert body.include?('memberships'), 'JSON response should include memberships'
    body["memberships"].each do |m|
      assert m.has_key?("calculated"), "JSON response's 'memberships' section should include a calculated flag"
      assert m["entity_id"], "JSON response's 'memberships' section should include an entity_id"
      assert m["id"], "JSON response's 'memberships' section should include a id"
      assert m.has_key?("loginid"), "JSON response's 'memberships' section should include a loginid"
      assert m["name"], "JSON response's 'memberships' section should include a name"
    end

    assert body.include?('operators'), 'JSON response should include operators'
    body["operators"].each do |o|
      assert o["id"], "JSON response's 'operators' section should include id"
      assert o["loginid"], "JSON response's 'operators' section should include loginid"
      assert o["name"], "JSON response's 'operators' section should include name"
    end

    assert body.include?('owners'), 'JSON response should include owners'
    body["owners"].each do |o|
      assert o["id"], "JSON response's 'owners' section should include id"
      assert o["loginid"], "JSON response's 'owners' section should include loginid"
      assert o["name"], "JSON response's 'owners' section should include name"
    end

    assert body.include?('rules'), 'JSON response should include rules'
    body["rules"].each do |r|
      assert r["id"], "JSON response's 'rules' section should include a name"
      assert r["column"], "JSON response's 'rules' section should include column"
      assert r["condition"], "JSON response's 'rules' section should include condition"
      assert r["value"], "JSON response's 'rules' section should include value"
    end
  end

  test 'JSON show request for a Person should include certain attributes' do
    grant_test_user_admin_access

    get :show, :format => :json, :id => @person.id

    body = JSON.parse(response.body)

    assert body.include?('id'), 'JSON response should include id field'
    assert body.include?('name'), 'JSON response should include name field'
    assert body.include?('type'), 'JSON response should include type field'
    assert body.include?('active'), 'JSON response should include active field'
    assert body.include?('address'), 'JSON response should include address field'
    assert body.include?('byline'), 'JSON response should include byline field'
    assert body.include?('email'), 'JSON response should include email field'
    assert body.include?('first'), 'JSON response should include first field'
    assert body.include?('last'), 'JSON response should include last field'
    assert body.include?('loginid'), 'JSON response should include loginid field'
    assert body.include?('phone'), 'JSON response should include phone field'

    assert body.include?('favorites'), 'JSON response should include favorites'
    body["favorites"].each do |f|
      assert f["id"], "JSON response's 'favorites' section should include a id"
      assert f["type"], "JSON response's 'favorites' section should include a type"
      assert f["name"], "JSON response's 'favorites' section should include a name"
    end

    assert body.include?('group_memberships'), 'JSON response should include group_memberships'
    body["group_memberships"].each do |m|
      assert m["id"], "JSON response's 'group_memberships' section should include id"
      assert m["group_id"], "JSON response's 'group_memberships' section should include group_id"
      assert m.has_key?("calculated"), "JSON response's 'group_memberships' section should include calculated"
      assert m["name"], "JSON response's 'group_memberships' section should include name"
    end

    assert body.include?('group_operatorships'), 'JSON response should include group_operatorships'
    body["group_operatorships"].each do |m|
      assert m["id"], "JSON response's 'group_operatorships' section should include id"
      assert m["group_id"], "JSON response's 'group_operatorships' section should include group_id"
      assert m["name"], "JSON response's 'group_operatorships' section should include name"
    end

    assert body.include?('group_ownerships'), 'JSON response should include group_ownerships'
    body["group_ownerships"].each do |m|
      assert m["id"], "JSON response's 'group_ownerships' section should include id"
      assert m["group_id"], "JSON response's 'group_ownerships' section should include group_id"
      assert m["name"], "JSON response's 'group_ownerships' section should include name"
    end

    assert body.include?('organizations'), 'JSON response should include organizations'
    body["organizations"].each do |o|
      assert o["id"], "JSON response's 'organizations' section should include id"
      assert o["name"], "JSON response's 'organizations' section should include name"
    end

    assert body.include?('role_assignments'), 'JSON response should include role_assignments'
    body["role_assignments"].each do |a|
      assert a["application_id"], "JSON response's 'role_assignments' section should include application_id"
      assert a["application_name"], "JSON response's 'role_assignments' section should include application_name"
      assert a.has_key?("calculated"), "JSON response's 'role_assignments' section should include calculated"
      assert a["description"], "JSON response's 'role_assignments' section should include description"
      assert a["entity_id"], "JSON response's 'role_assignments' section should include entity_id"
      assert a["id"], "JSON response's 'role_assignments' section should include id"
      assert a["name"], "JSON response's 'role_assignments' section should include name"
      assert a["role_id"], "JSON response's 'role_assignments' section should include role_id"
      assert a["token"], "JSON response's 'role_assignments' section should include token"
    end
  end
end
