class MapContact < ApplicationRecord
  translates :name, :long_name, :alt_name, :address, :tel, :fax, :website_name
end
