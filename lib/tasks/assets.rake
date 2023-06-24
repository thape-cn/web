# frozen_string_literal: true

namespace :assets do
  desc "Compile all the assets"
  task precompile: ["yarn:install", "shakapacker:compile"]
end
