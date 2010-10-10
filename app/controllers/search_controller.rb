class SearchController < ApplicationController
  # /stops/search/006
  def search
    memo = []
    memo += Route.where(:uid => params['q'].downcase).map {|route|
      {:type => 'route', :route => route.to_hash}
    }
    memo += Stop.where(:name => params['q']).map {|stop|
      {:type => 'stop', :stop => stop.to_hash}
    }
    memo += Stop.where(Arel::Table.new(:stops)[:name].matches("%#{params['q']}%")).map {|stop|
      {:type => 'stop', :stop => stop.to_hash}
    }
    render :json => memo.to_json
  end
end
