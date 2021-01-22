# frozen_string_literal: true

Rails.application.routes.draw do
  get '/cn/biz-map', to: redirect { |params, req| '/biz-map' }
  get '/cn/management', to: redirect { |params, req| '/leadership' }
  get '/cn/designing', to: redirect { |params, req| '/leadership' }
  get '/cn/people', to: redirect { |params, req| '/leadership' }
  get '/cn/about-us', to: redirect { |params, req| '/about' }
  get '/cn/news', to: redirect { |params, req| '/news' }
  get '/cn/news/:id', to: redirect { |params, req| "/news/#{params[:id]}" }
  get '/cn/cases', to: redirect { |params, req| '/works' }
  get '/cn/building', to: redirect { |params, req| '/building' }
  get '/cn/interior', to: redirect { |params, req| '/interior' }
  get '/cn/planning', to: redirect { |params, req| '/planning' }
  get '/cn/landscape', to: redirect { |params, req| '/landscape' }
  get '/cn/consluting', to: redirect { |params, req| '/consluting' }
  get '/cn/vetting', to: redirect { |params, req| '/vetting' }
  get '/cn/vr-tech', to: redirect { |params, req| '/vr-tech' }
  get '/cn/management/:id', to: redirect { |params, req| "/leadership/#{params[:id]}" }
  get '/cn/designing/:id', to: redirect { |params, req| "/leadership/#{params[:id]}" }
  get '/cn/people/:id', to: redirect { |params, req| "/leadership/#{params[:id]}" }
  get '/cn/service/building', to: redirect { |params, req| '/building' }
  get '/cn/service/interior', to: redirect { |params, req| '/interior' }
  get '/cn/service/planning', to: redirect { |params, req| '/planning' }
  get '/cn/service/landscape', to: redirect { |params, req| '/landscape' }
  get '/cn/service/consluting', to: redirect { |params, req| '/consluting' }
  get '/cn/service/vetting', to: redirect { |params, req| '/vetting' }
  get '/cn/service/vr-tech', to: redirect { |params, req| '/vr-tech' }
  get '/cn/contact-us', to: redirect { |params, req| '/biz-map' }
  get '/cn/contact', to: redirect { |params, req| '/biz-map' }

  get '/en/biz-map', to: redirect { |params, req| '/biz-map?locale=en' }
  get '/en/management', to: redirect { |params, req| '/leadership?locale=en' }
  get '/en/designing', to: redirect { |params, req| '/leadership?locale=en' }
  get '/en/people', to: redirect { |params, req| '/leadership?locale=en' }
  get '/en/about-us', to: redirect { |params, req| '/about?locale=en' }
  get '/en/news', to: redirect { |params, req| '/news?locale=en' }
  get '/en/news/:id', to: redirect { |params, req| "/news/#{params[:id]}?locale=en" }
  get '/en/cases', to: redirect { |params, req| '/works?locale=en' }
  get '/en/building', to: redirect { |params, req| '/building?locale=en' }
  get '/en/interior', to: redirect { |params, req| '/interior?locale=en' }
  get '/en/planning', to: redirect { |params, req| '/planning?locale=en' }
  get '/en/landscape', to: redirect { |params, req| '/landscape?locale=en' }
  get '/en/consluting', to: redirect { |params, req| '/consluting?locale=en' }
  get '/en/vetting', to: redirect { |params, req| '/vetting?locale=en' }
  get '/en/vr-tech', to: redirect { |params, req| '/vr-tech?locale=en' }
  get '/en/management/:id', to: redirect { |params, req| "/leadership/#{params[:id]}?locale=en" }
  get '/en/designing/:id', to: redirect { |params, req| "/leadership/#{params[:id]}?locale=en" }
  get '/en/people/:id', to: redirect { |params, req| "/leadership/#{params[:id]}?locale=en" }
  get '/en/service/building', to: redirect { |params, req| '/building?locale=en' }
  get '/en/service/interior', to: redirect { |params, req| '/interior?locale=en' }
  get '/en/service/planning', to: redirect { |params, req| '/planning?locale=en' }
  get '/en/service/landscape', to: redirect { |params, req| '/landscape?locale=en' }
  get '/en/service/consluting', to: redirect { |params, req| '/consluting?locale=en' }
  get '/en/service/vetting', to: redirect { |params, req| '/vetting?locale=en' }
  get '/en/service/vr-tech', to: redirect { |params, req| '/vr-tech?locale=en' }
  get '/en/contact-us', to: redirect { |params, req| '/biz-map?locale=en' }
  get '/en/contact', to: redirect { |params, req| '/biz-map?locale=en' }

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
  resources :leadership, only: [:index, :show]

  resource :about, only: %i[show]
  get 'about-us', to: 'abouts#about_us'
  get 'culture', to: 'abouts#culture'

  get 'building', to: 'services#building'
  get 'interior', to: 'services#interior'
  get 'planning', to: 'services#planning'
  get 'landscape', to: 'services#landscape'
  get 'vetting', to: 'services#vetting'
  get 'consluting', to: 'services#consluting'
  get 'vr-tech', to: 'services#vrtech'
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

  resources :tianhua2019s, only: %i[show index]
  resources :tianhua2020s, only: %i[show index create] do
    member do
      get :flag_board
    end
  end

  root 'home#show'
end
