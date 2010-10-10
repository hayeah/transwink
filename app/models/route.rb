require 'translink'
class Route < ActiveRecord::Base
  has_many :stops
  def self.populate
    api = Translink.new
    Route.transaction do
      Route.delete_all
      Stop.delete_all
      api.routes[0..5].each do |route|
        p route.name
        record = Route.create(:uid => route.id,:name => route.name)
        (route.west + route.east).each do |stop|
          p stop.name
          record.stops.create(:uid => stop.id,
                              :name => stop.name,
                              :direction => stop.direction,
                              :times => stop.times,
                              :x => stop.x,
                              :y => stop.y)
        end
      end
    end
  end

  def west
    stops.where(:direction => "West")
  end

  def east
    stops.where(:direction => "East")
  end

  def to_hash
    {
      "route_id" => uid,
      "name" => name,
      "west" => west.map(&:to_hash),
      "east" => east.map(&:to_hash)
    }
  end
end
