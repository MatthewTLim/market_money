class MarketSerializer
  include JSONAPI::Serializer
  set_id :id
  set_type :market
  has_many :vendors
  attributes :name, :street, :city, :county, :state, :zip, :lat, :lon, :vendor_count
end
