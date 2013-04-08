class CyclesController < ApplicationController

  def index
      @cycles = Cycle.search(params[:search]).page(params[:page]).per(20)
    @next_page = (params[:page].to_i||0)+1
    if params[:infinite]
      respond_to do |format|
        format.js { render 'infinite' }
      end
    else
      respond_to do |format|
        format.js
        format.html {
          init
        }
      end
    end
  end

  def init
    @brands = Cycle.count(:group=>:brand)
    @types = Cycle.count(:group=>:cycle_type)
    @ages = Cycle.count(:group=>:age)
    @max_price = Cycle.maximum("price")
  end
end
