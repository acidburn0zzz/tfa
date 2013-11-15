Feature: Assign roles
	In order to reach certian resources
	A user
	Should be assigned a role

	Scenario: New user has user role
		Given I exist as a user
		And I am not logged in
		When I sign in with valid credentials
		Then I go to the OTP page
		When I enter a valid OTP
		Then I should be signed in
		And I should have the user role

	Scenario: Regular user tries to view all users
		Given I am logged in as a user
		When I try to view all users
		Then I should see an authorization error


