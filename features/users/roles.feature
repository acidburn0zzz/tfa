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
