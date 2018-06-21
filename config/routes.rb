Rails.application.routes.draw do
  get "signup", to: "users#new", as: "signup"
  get "login", to: "sessions#new", as: "login"
  get "logout", to: "sessions#destroy", as: "logout"
  
  resources :users
  resources :sessions

  resources :videos do
    collection do
      get :load_suggestions
    end
  end
  get "tags/:tag", to: "videos#index", as: :tag
  root to: "videos#index"
  
  resources :search_title_suggestions
  resources :search_tag_suggestions

  get "tag_collection", to: "search_tags#tag_collection"

  get "trailer" => "trailer#trailer"
  get "self_embed" => "trailer#youtube_self"

  get "self_tmdb" => "tmdb#tmdb_self"

  get "embed_player" => "embedable_logic#embed_player"
  get "wf2_embed_player" => "embedable_logic#wf2_embed_player"
  get "follow_links" => "embedable_logic#follow_links"
  get "prime_openload" => "embedable_logic#embed_prime_openload"
  get "prime_openload_player" => "embedable_logic#prime_openload_player"
  get "embed_episode" => "embedable_logic#embed_episode"

  get "tasks" => "tasks#tasks"
  get "kat" => "tasks#kat"
  get "primewire" => "tasks#primewire"
  get "wes" => "tasks#watchepisodeseries"
  get "watchfree" => "tasks#watchfree"
  get "watchfree_tv" => "tasks#watchfree_tv"
  get "featured" => "tasks#featured"
  get "dupes" => "tasks#duplicates"
 
  # gcs routes =======================================
  
  get "gcs_youtube" => "gcs#youtube"
  get "gcs_mtv" => "gcs#mtv"
  get "gcs_vevo" => "gcs#vevo"
  get "gcs_toonme_net" => "gcs#toonme_net"
  get "gcs_watchcartoon_tv" => "gcs#watchcartoontv"
  get "gcs_cartooncrazy_me" => "gcs#cartooncrazy"
  get "gcs_quedustream" => "gcs#quedustream"
  get "gcs_streamdown" => "gcs#streamdown"
  get "gcs_seriesenstreaming" => "gcs#seriesenstreaming"
  get "gcs_zone" => "gcs#zone_telechargement"
  get "gcs_youwatchseries" => "gcs#youwatchseries"
  get "gcs_watchtvlinks" => "gcs#watchtvlinks"
  get "gcs_iwatchonline" => "gcs#iwatchonline"
  get "gcs_onwatchseries" => "gcs#onwatchseries"
  get "gcs_streamin" => "gcs#streamin"
  get "gcs_primeseries" => "gcs#primeseries"
  get "gcs_watchepisodeseries" => "gcs#watchepisodeseries"
  get "gcs_watchfilmi" => "gcs#watchfilmi"
  get "gcs_openloadmovies" => "gcs#openloadmovies"
  get "gcs_movie9k" => "gcs#movie9k"
  get "gcs_movietubenow" => "gcs#movietubenow"
  get "gcs_watchseriesfree" => "gcs#watchseriesfree"
  get "gcs_xmovies8" => "gcs#xmovies8"
  get "gcs_gomovies" => "gcs#gomovies"
  get "gcs_mydownloadtube_tv" => "gcs#mydownloadtube_tv"
  get "gcs_mydownloadtube_com" => "gcs#mydownloadtube_com"
  get "gcs_watchfree" => "gcs#watchfree"
  get "gcs_primewire" => "gcs#primewire"
  get "gcs_putlockers" => "gcs#putlockers"
  get "gcs_youwatch" => "gcs#youwatch"
  get "gcs_yamivideo" => "gcs#yamivideo"
  get "gcs_xvidstage" => "gcs#xvidstage"
  get "gcs_thevideo" => "gcs#thevideo"
  get "gcs_nowvideo" => "gcs#nowvideo"
  get "gcs_nosvideo" => "gcs#nosvideo"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
