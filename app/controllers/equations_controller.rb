class EquationsController < ApplicationController
  load_and_authorize_resource  
  def edit    
  end
  
  def update
    if @equation.update_attributes(params[:equation])
      redirect_to @equation, notice: "Equation updated successfully."
    else
      render action: 'edit'
    end
  end
  
  def show
    
  end
  
end