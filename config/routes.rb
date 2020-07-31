Rails.application.routes.draw do
  get '/cn/designing', to: redirect { |params, req| "/leadership" }
  get '/cn/about-us', to: redirect { |params, req| "/about" }

  resources :works, only: %i[index show] do
    collection do
      get :residential
      get :"residential-rental"
      get :"residential-community"
      get :"residential-residence"
      get :"demonstration-zone"
      get :office
      get :supertall
      get :"mixed-used-tod"
      get :commercial
      get :cultural
      get :education
      get :"medical-care"
      get :"urban-design"
      get :hospitality
      get :"urban-planning"
      get :landscape
      get :interior
    end
  end
  resources :managements, only: [:index, :show]
  resources :leadership, only: [:index, :show]

  resource :about, only: %i[show]
  get 'about-us', to: 'abouts#about_us'
  get 'culture', to: 'abouts#culture'

  get 'building', to: "services#building"
  get 'interior', to: "services#interior"
  get 'planning', to: "services#planning"
  get 'landscape', to: "services#landscape"
  get 'vetting', to: "services#vetting"
  get 'consluting', to: "services#consluting"
  get 'vr-tech', to: "services#vrtech"
  get 'biz-map', to: 'biz_maps#show'

  resources :sites, only: [] do
    collection do
      get :statement
      get :privacy
      get :disclaimer
    end
  end

  resources :news, only: %i[index show]
  resources :guest_messages, only: %i[create]

  get 'search', to: 'search#query'

  root 'home#show'
end
