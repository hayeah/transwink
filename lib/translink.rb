require 'httparty'
require 'json'
require RUBY_VERSION < '1.9' ? 'fastercsv' : 'csv'
require 'pp'

# we can use cron to update the schedule every 40 minutes (or something)
class Translink
  class API
    class << self
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
  end

  class Stop
    attr_reader :id, :name, :times, :direction
    class << self
      def csv
        return @csv if @csv
        @csv = {}
        # {"parent_station"=>" ",
        #   "stop_code"=>"50004",
        #   "stop_lat"=>"49.282093",
        #   "stop_lon"=>"-123.140503",
        #   "stop_id"=>"4",
        #   "zone_id"=>"1",
        #   "location_type"=>"0",
        #   "stop_url"=>" ",
        #   "stop_desc"=>"BEACH AV @ NICOLA ST",
        #   "stop_name"=>"EB BEACH AV FS NICOLA ST"}
        (RUBY_VERSION < '1.9' ? FasterCSV : CSV).open("data/stops.txt",:headers => true).each do |row|
          @csv[row["stop_code"].to_i] = row.to_hash
        end
        @csv
      end
    end

    attr_reader :attributes, :id, :x, :y, :name, :times
    def initialize(attr)
      @id = attr["stopID"]
      if @extra = Stop.csv[@id]
        @x = @extra["stop_lon"]
        @y = @extra["stop_lat"]
      end
      @direction = attr["direction"]
      @name = attr["stopName"]
      @times = attr["times"].join("$")
      @attributes = attr
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

    def north
      @north ||= stops("North")
    end

    def south
      @south ||= stops("South")
    end

    def to_json
      { "id" => id,
        "name" => name,
        "west" => west.map(&:to_json),
        "east" => east.map(&:to_json)}
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

class << Translink
  # eager load the values in parallel
  def scrape_1
    api = Translink.new
    route = api.routes.first
    stops = route.west
    p stops.length
    
    stops.each do |s|
      p s.name
      p s.to_json
    end
  end

  def scrape_2
    api = Translink.new
    route = api.routes.first
    stops = route.west
    p stops.length
  end
end

# pp Translink::Stop.csv.keys.uniq.size

# case ARGV[1]
# when "2"
#   Translink.scrape_2
# else
#   Translink.scrape_1
# end


# # pp stop
# pp stop.xy

