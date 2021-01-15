# frozen_string_literal: true

namespace :sitemap do
  desc 'Update thape web sitemap'
  task :update_sitemap do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'sitemap:refresh'
        end
      end
    end
  end

  after 'deploy:updated',  'sitemap:update_sitemap'
  after 'deploy:reverted', 'sitemap:update_sitemap'
end
