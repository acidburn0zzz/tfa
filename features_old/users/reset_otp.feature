Feature: Reset OTP Secret
	As a member of the website
	I want to reset my OTP secret
	so I can rescan the barcode

	Scenario: I sign in as a user and reset my secret
		Given I am logged in as a user
		And I am on the Edit account page
		When I click the Reset OTP secret button
		Then I should see a QR code
