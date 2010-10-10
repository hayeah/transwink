class Stop < ActiveRecord::Base
  belongs_to :route
  # stop_id,stop_code,stop_name,stop_desc,stop_lat,stop_lon,zone_id,stop_url,location_type,parent_station
  def to_hash
    attributes
  end
end
