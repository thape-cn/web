class MapContact < ApplicationRecord
  translates :name, :long_name, :address, :tel, :fax
end
