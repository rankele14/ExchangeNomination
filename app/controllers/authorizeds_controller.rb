# frozen_string_literal: true

class AuthorizedsController < ApplicationController
  before_action :set_authorized, only: %i[show edit update destroy]

  # GET /authorizeds or /authorizeds.json
  def index
    @authorizeds = Authorized.all
  end

  # GET /authorizeds/1 or /authorizeds/1.json
  def show; end

  # GET /authorizeds/new
  def new
    @authorized = Authorized.new
  end

  # GET /authorizeds/1/edit
  def edit; end

  # POST /authorizeds or /authorizeds.json
  def create
    @authorized = Authorized.new(authorized_params)

    respond_to do |format|
      if @authorized.save
        format.html { redirect_to @authorized, notice: 'Authorized was successfully created.' }
        format.json { render :show, status: :created, location: @authorized }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @authorized.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authorizeds/1 or /authorizeds/1.json
  def update
    respond_to do |format|
      if @authorized.update(authorized_params)
        format.html { redirect_to @authorized, notice: 'Authorized was successfully updated.' }
        format.json { render :show, status: :ok, location: @authorized }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @authorized.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authorizeds/1 or /authorizeds/1.json
  def destroy
    @authorized.destroy
    respond_to do |format|
      format.html { redirect_to authorizeds_url, notice: 'Authorized was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_authorized
    @authorized = Authorized.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def authorized_params
    params.require(:authorized).permit(:authorized_email)
  end
end
