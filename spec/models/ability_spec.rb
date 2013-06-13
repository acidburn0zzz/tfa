require 'spec_helper'

describe CanCan::Ability do

	before(:each) do
		@attr = {
			:name => "Example User",
			:email => "user@example.com",
			:password => "changeme",
			:password_confirmation => "changeme"
		}
	end

	it "should allow an admin to manage all records" do
		users = User.all
		@user = User.create!(@attr)
		@user.add_role :admin
		a = Ability.new(@user)
		a.can?(:read, users).should == true
	end
end
