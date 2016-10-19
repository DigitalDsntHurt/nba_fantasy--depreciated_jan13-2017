Rails.application.routes.draw do

  get 'debug/index'
  get 'debug' => 'debug#index'

  get 'player_games/index'
  get 'player_games' => 'player_games#index'

  get 'players/index'
  get 'players' => 'players#index'
  get 'player/:id' => 'player#show'

  get 'player_pool/index'
  get 'player_pool' => 'player_pool#index'
  get 'player_pool/import'
  get 'player_pool/create'
  get 'player/show'
  post 'player_pool/delete_pool' => 'player_pool', via: :delete
  resources :player_pool do
    collection { post :import }
  end
  
  get 'lineups/index'
  get 'lineups' => 'lineups#index'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
