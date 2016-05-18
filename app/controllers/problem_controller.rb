class ProblemController < ApplicationController

  def list
    @problems = Problem.all
  end

end
