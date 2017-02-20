class LonguestWordController < ApplicationController
  
  def generate_grid
    (0...9).map { ('A'..'Z').to_a[rand(26)] }
  end
  
  def game
    @grid = generate_grid
  end
  
  def translation(attempt)
    key = "90bc5d04-1704-4c45-ae6a-bcf602928f6b"
    systran_url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{key}&input=#{attempt}"
    url_serialized = open(systran_url).read
    json_parsing = JSON.parse(url_serialized)
    infos = json_parsing["outputs"]
    new_infos = infos.reduce Hash.new, :merge
    return new_infos["output"]
  end
  
  def time_taken(start_time, end_time)
    time_taken = end_time - start_time
    return time_taken
  end
  
  def compute_score(attempt, start_time, end_time)
    (time_taken(start_time, end_time) > 60.0) ? 0 : attempt.size * (1.0 - time_taken(start_time, end_time) / 60.0)
  end
  
  # def run_game(attempt, grid, start_time, end_time)
  
  def run_game(attempt, grid, start_time, end_time)
      @informations = {}
      @informations[:time] = time_taken(start_time, end_time)
      @informations[:translation] = translation(attempt)
      @informations[:attempt] = attempt
      @informations[:score] = compute_score(attempt, start_time, end_time)
    end

  def score
    attempt = params[:query]
    start_time = params[:start_time].to_time
    end_time = Time.now
    grid = @grid
    @result = run_game(attempt, grid, start_time, end_time)
  end
end
