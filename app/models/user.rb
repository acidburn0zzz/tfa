class User < ActiveRecord::Base
	rolify
	# Include default devise modules. Others available are:
	# :token_authenticatable, :confirmable,
	# :lockable, :timeoutable and :omniauthable
	devise :two_factor_authenticatable, :database_authenticatable, :registerable,
		:recoverable, :trackable, :validatable

	# Setup accessible (or protected) attributes for your model
	attr_accessible :role_ids, :as => :admin
	attr_accessible :name, :email, :password, :password_confirmation, :otp_secret
	validates :email, :uniqueness => true

	after_create :assign_default_role

	def assign_default_role
		add_role(:user) if self.roles.blank?
	end
end
