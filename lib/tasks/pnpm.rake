# frozen_string_literal: true

namespace :pnpm do
  desc "Install JavaScript dependencies with pnpm using the existing lockfile"
  task :install do
    puts "Running pnpm install --frozen-lockfile"
    success = system("pnpm", "install", "--frozen-lockfile")
    raise "pnpm install failed" unless success
  end
end
