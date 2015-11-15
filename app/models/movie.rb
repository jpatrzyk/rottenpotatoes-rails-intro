class Movie < ActiveRecord::Base
    def Movie.all_ratings
        Movie.uniq.pluck(:rating)
    end
end
