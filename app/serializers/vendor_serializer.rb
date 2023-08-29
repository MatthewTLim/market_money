class VendorSerializer
  include JSONAPI::Serializer
  set_id :id
  set_type :vendor
  attributes :name, :description, :contact_name, :contact_phone, :credit_accepted
end
