Rails.application.routes.draw do
  post 'message_process', to: 'message#message_process'
  get 'classifica', to: 'message#classifica'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
