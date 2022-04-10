# frozen_string_literal: true

require 'common_stuff'
class RepresentativesController < ApplicationController
  include CommonStuff
  before_action :set_representative, only: %i[show edit update destroy]

  # GET /representatives or /representatives.json
  def index
    @representatives = Representative.all
  end

  # GET /representatives/1 or /representatives/1.json
  def show; end

  # GET /representatives/1/user_show
  def user_show
    @representative = Representative.find(params[:id])
  end

  # GET /representatives/new
  def new
    @representative = Representative.new
  end

  # GET /representatives/user_new
  def user_new
    @representative = Representative.new
  end

  # GET /representatives/1/edit
  def edit; end

  # GET /representatives/1/user_edit
  def user_edit
    @representative = Representative.find(params[:id])
  end

  # POST /representatives or /representatives.json
  def create
    @representative = Representative.new(representative_params)

    respond_to do |format|
      if @representative.save
        format.html { redirect_to representative_url(@representative), notice: 'Nominator was successfully created.' }
        format.json { render :show, status: :created, location: @representative }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @representative.errors, status: :unprocessable_entity }
      end
    end
  end

  def user_create
    @representative = Representative.new(representative_params)
    @deadline = Variable.find_by(var_name: 'deadline')
    if !@deadline.nil? && Time.now > @deadline.var_value # past the deadline
      redirect_to deadline_dashboards_path
    else
      respond_to do |format|
        if @representative.save
          format.html do
            redirect_to user_show_representative_url(@representative), notice: 'Nominator was successfully created.'
          end
          format.json { render :show, status: :created, location: @representative }
        else
          format.html { render :user_new, status: :unprocessable_entity }
          format.json { render json: @representative.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /representatives/1 or /representatives/1.json
  def update
    @uni_prev = University.find(@representative.university_id)
    respond_to do |format|
      if @representative.update(representative_params)
        @university = University.find(@representative.university_id)
        if @uni_prev != @university
          @students = Student.where(representative_id: @representative.id)
          @students.each do |student|
            student.university_id = @representative.university_id
            student.save
            if student.exchange_term.include? 'and'
              @university.num_nominees = @university.num_nominees + 2
              @uni_prev.num_nominees = @uni_prev.num_nominees - 2
            else
              @university.num_nominees = @university.num_nominees + 1
              @uni_prev.num_nominees = @uni_prev.num_nominees - 1
            end
            @university.save
            @uni_prev.save
          end
        end
        format.html { redirect_to representative_url(@representative), notice: 'Nominator was successfully updated.' }
        format.json { render :show, status: :ok, location: @representative }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @representative.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /representatives/1 or /representatives/1.json
  def user_update
    @representative = Representative.find(params[:id])
    @deadline = Variable.find_by(var_name: 'deadline')

    if !@deadline.nil? && Time.now > @deadline.var_value # past the deadline
      redirect_to finish_representative_url(@representative),
                  alert: 'Sorry, the deadline for submitting students has passed'
    else
      respond_to do |format|
        if @representative.update(representative_params)
          format.html do
            redirect_to user_show_representative_url(@representative), notice: 'Nominator was successfully updated.'
          end
          format.json { render :show, status: :ok, location: @representative }
        else
          format.html { render :user_edit, status: :unprocessable_entity }
          format.json { render json: @representative.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /representatives/1 or /representatives/1.json
  def delete
    @representative = Representative.find(params[:id])
  end

  def destroy
    @students = Student.where(representative_id: @representative.id)
    @students.each do |student|
      destroy_uni_update(student.id)
    end
    @representative.destroy

    respond_to do |format|
      format.html { redirect_to representatives_url, notice: 'Nominator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def finish
    @representative = Representative.find(params[:id])
    @students = Student.where(representative_id: @representative.id)
    @university = University.find(@representative.university_id)
    @deadline = Variable.find_by(var_name: 'deadline')
  end

  def test_method
    @representative.update(first_name: 'Updated')
  end

  def rep_redirect
    user_new_student_path
  end

  def clear_all
    @representatives = Representative.all
  end

  def destroy_all
    @representatives = Representative.all
    @representatives.each do |representative|
      @students = Student.where(representative_id: representative.id)
      @students.each do |student|
        destroy_uni_update(student.id)
      end
      representative.destroy
    end
    # automatically destroys rep's students
    redirect_to representatives_url, notice: 'Representatives successfully cleared.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_representative
    @representative = Representative.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def representative_params
    params.require(:representative).permit(:first_name, :last_name, :title, :university_id, :rep_email)
  end
end
