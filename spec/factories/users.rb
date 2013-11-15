# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :user do
		name 'Test User'
		email 'example@example.com'
		password 'changeme'
		password_confirmation 'changeme'
		otp_secret "lqdjuj4z6cvudk3v"
		# required if the Devise Confirmable module is used
		# confirmed_at Time.now
	end

	factory :admin, :class => User do
		name 'Admin'
		email 'admin@admin.com'
		password 'changeme'
		password_confirmation 'changeme'
		otp_secret "lqdjuj4z6cvudk3v"
	end
end
