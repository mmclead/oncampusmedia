class ImportsController < ApplicationController
  load_and_authorize_resource
  def new
    
  end
  
  def create
    @import = Import.new(params[:import])
    @import.save
    redirect_to @import
  end
  
  def show
    @schools_file_import_status = @import.schools_import_has_run
    @transactions_file_import_status = @import.transactions_import_has_run
    @rotc_file_import_status = @import.rotc_import_has_run
    @schedules_file_import_status = @import.schedules_import_has_run
    @summer_schedules_file_import_status = @import.summer_schedules_import_has_run
    if @import.schools_import_has_run
      @new_schools = School.where(school_name: @import.imported_schools[0])
      @updated_schools = @import.imported_schools[1]
    end
  end
  
  def run_import
    type = params[:type].slice(0..-6)
    @import.mark_as_running(type)
    @import.delay.import_file(params[:type])
    
    redirect_to @import, notice: "Import Started"
  end
  
end
