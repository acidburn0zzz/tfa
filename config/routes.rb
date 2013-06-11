Tfa::Application.routes.draw do
	devise_for :users, :controllers => { :registrations => "registrations" }
	authenticated :user do
		root :to => 'home#index'
		resources :users do
			member do
				get "reset_secret" => "users#reset_secret"
				get "delete_qr_code" => "users#delete_qr_code"
			end
		end
	end
	devise_scope :user do
		root :to => "devise/sessions#new"
	end
	resources :users
end
