class PlayController < ApplicationController
  def play
    @problem_id = params[:problem_id]
  end
end
