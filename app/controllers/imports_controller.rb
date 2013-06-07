class ImportsController < ApplicationController
  load_and_authorize_resource
  def new
    
  end
  
  def create
    @import = Import.new(params[:import])
    @import.save
    respond_with @import  
  end
  
  def show
    
  end
end
