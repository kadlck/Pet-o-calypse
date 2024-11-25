class ApocalypsesController < ApplicationController
  def index
    @pet = Pet.find(params[:id])
    @apocalypse = @pet.apocalypse
    @events = @apocalypse.events
  end

  def show
    @apocalypse = Apocalypse.find(params[:id])
  end
end
