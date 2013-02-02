class CyclesController < ApplicationController

  def index
    @cycles = Cycle.where(:flag=>true).page(params[:page]).per(20)
    respond_to do |format|
      format.js
      format.html 
    end
  end
end
