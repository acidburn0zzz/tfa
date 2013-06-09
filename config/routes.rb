Tfa::Application.routes.draw do
	devise_for :users
	authenticated :user do
		root :to => 'home#index'
		resources :users do
			member do
				get "reset_secret" => "users#reset_secret"
			end
		end
	end
	root :to => "home#index"
	resources :users
end
