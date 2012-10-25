class Movie < ActiveRecord::Base
  def self.AllRatings
    return Movie.all(:select => :rating).map(&:rating).uniq
  end
end
