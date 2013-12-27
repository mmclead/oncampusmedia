class AmbassadorsController < ApplicationController


  load_and_authorize_resource  
  # GET /ambassadors
  # GET /ambassadors.json
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ambassadors }
    end
  end

  # GET /ambassadors/1
  # GET /ambassadors/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ambassador }
    end
  end

  # GET /ambassadors/new
  # GET /ambassadors/new.json
  def new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ambassador }
    end
  end

  # GET /ambassadors/1/edit
  def edit
  end

  # POST /ambassadors
  # POST /ambassadors.json
  def create

    respond_to do |format|
      if @ambassador.save
        format.html { redirect_to @ambassador, notice: 'Ambassador was successfully created.' }
        format.json { render json: @ambassador, status: :created, location: @ambassador }
      else
        format.html { render action: "new" }
        format.json { render json: @ambassador.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ambassadors/1
  # PUT /ambassadors/1.json
  def update

    respond_to do |format|
      if @ambassador.update_attributes(params[:ambassador])
        format.html { redirect_to @ambassador, notice: 'Ambassador was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ambassador.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ambassadors/1
  # DELETE /ambassadors/1.json
  def destroy
    @ambassador.destroy

    respond_to do |format|
      format.html { redirect_to ambassadors_url }
      format.json { head :no_content }
    end
  end
end
