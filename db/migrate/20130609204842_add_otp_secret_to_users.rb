class AddOtpSecretToUsers < ActiveRecord::Migration
	def up
		change_table :users do |t|
			t.string :otp_secret
		end
	end

	def down
		remove_column :users, :otp_seret
	end
end
