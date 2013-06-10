Tfa::Application.routes.draw do
	devise_for :users
	authenticated :user do
		root :to => 'users#index'
		resources :users do
			member do
				get "reset_secret" => "users#reset_secret"
			end
		end
	end
	#root :to => 'users#index'
	devise_scope :user do
		root :to => "devise/sessions#new"
	end
	resources :users
end
