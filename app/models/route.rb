require 'translink'
class Route < ActiveRecord::Base
  has_many :stops
  def self.populate(n=nil)
    api = Translink.new
    Route.transaction do
      Route.delete_all
      Stop.delete_all
      routes = api.routes
      if n
        routes = routes[0..n]
      end
      routes.each do |route|
        record = Route.create(:uid => route.id,:name => route.name)
        (route.west + route.east + route.north + route.south).each do |stop|
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
    direction("West")
  end

  def east
    direction("East")
  end

  def north
    direction("North")
  end

  def south
    direction("South")
  end

  def direction(dir)
    stops.where(:direction => dir)
  end

  def to_hash
    {
      "route_id" => uid,
      "name" => name,
      "west" => west.map(&:to_hash),
      "east" => east.map(&:to_hash),
      "north" => north.map(&:to_hash),
      "south" => south.map(&:to_hash)
    }
  end
end
