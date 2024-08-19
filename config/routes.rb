Rails.application.routes.draw do
  resources :users
  default_url_options :host => "encurtador.com"

  get '/s/:slug', to: 'link#show', as: :short
end
