require 'httparty'
require 'json'
require 'pp'

# we can use cron to update the schedule every 40 minutes (or something)
class Translink
  class API
    class << self
      def singleton
        @singleton ||= self.new
      end

      def get(resource,query,format=:json)
        singleton.get(resource,query,format)
      end
    end
    
    def get(resource,query,format=:json)
      response = HTTParty.get("http://m.translink.ca/api/#{resource}/#{query}",
                              :format => format)
      unless response.code == 200
        p response.message
        raise "shit"
      end
      response.parsed_response
    end
  end

  class Stop
    attr_reader :id, :name, :times
    def initialize(attr)
      p attr
      @id = attr["stopID"]
      @name = attr["stopName"]
      @times = attr["times"]
    end

    def xy
      # {"kml"=>
      #   {"Placemark"=>
      #     {"name"=>"#51842 Burrard Stn Bay 4",
      #       "Point"=>{"coordinates"=>"-123.121594,49.286591"}},
      #     "xmlns"=>"http://www.opengis.net/kml/2.2"}}
      @xy ||= API.get("kml/stop",id,:xml)["kml"]["Placemark"]["Point"]["coordinates"].split(",")
    end

    def x
      xy[0]
    end

    def y
      xy[1]
    end
  end

  class Route
    attr_reader :id, :name
    def initialize(id,name)
      @id = id
      @name = name
    end

    def west
      @west ||= stops("West")
    end

    def east
      @east ||= stops("East")
    end

    private

    def stops(direction="West")
      API.get("stops","?f=json&r=#{id}&d=#{direction}").map { |info|
        Stop.new(info)
      }
    end
  end

  def routes
    # hacky way to get all the routes
    @routes ||= API.get("routes","?q=0").map { |tuple|
      Route.new(id=tuple[0],name=tuple[1])
    }
  end
end


# api = Translink.new

# routes =  api.routes

# route = routes.first

# stop = route.west.first

# # pp stop
# pp stop.xy

