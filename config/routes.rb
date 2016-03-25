Rails.application.routes.draw do
  root to: 'home#index'

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
end
