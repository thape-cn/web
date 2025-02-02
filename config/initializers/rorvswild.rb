if Rails.env.production?
  RorVsWild.start(
    api_key: Rails.application.credentials.rorvswild_api_key,
    ignore_requests: ["SitesController#privacy"],
    ignore_jobs: [],
    ignore_exceptions: ["ActionController::UnknownFormat"],
    ignore_plugins: ["Elasticsearch","Mongo","Resque","DelayedJob","Sidekiq"]
    )
end
