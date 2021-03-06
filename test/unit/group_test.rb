require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    # Clear the cache in case fixtures changed recently (would interfere with flatten test, etc.)
    Rails.cache.clear
  end
  
  # Ensure members(:flatten = true) has the correct number of members
  test "members flattens a group correctly" do
    group = Group.first
    # Ensure the group exists
    assert group, "a group must exist for this test"
    # Ensure the group has person members
    assert group.members.select{ |m| m.type == "Person"}.count > 0, "cannot test without people assigned to this group"
    # Ensure the group has group members that are not empty
    assert group.members.select{ |m| m.type == "Group"}.count > 0, "cannot test without groups assigned to this group"
    
    flattened_members_count = group.flattened_members.count
    
    # Manually flatten the group and ensure g.members(:flatten = true)'s logic works correctly (the point of this test)
    # Technically this is a recursive test (we rely on g.members(true) working correctly). This should still
    # work but a replacement test version of members(:flatten = true) should be written. 
    test_flatten_count = 0
    test_flatten_count += group.members.select{ |m| m.type == "Person"}.count
    group.members.select{ |m| m.type == "Group"}.each do |g|
      test_flatten_count += g.flattened_members.count
    end
    
    assert test_flatten_count == flattened_members_count, "test flattening (#{test_flatten_count}) and Group.members(:flatten = true) (#{flattened_members_count}) should match count"
  end
end
