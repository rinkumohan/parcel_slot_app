require_relative "parcel_system"

#Program begins here
begin
  ParcelSystem.initiate
rescue => e
  puts "Something went wrong!"
end
