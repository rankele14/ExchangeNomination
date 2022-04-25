# frozen_string_literal: true

class UniversitiesController < ApplicationController
  before_action :set_university, only: %i[show edit update destroy]

  # GET /universities or /universities.json
  def index
    @universities = University.all
    @variable = Variable.find_by(var_name: 'max_limit')
    @max_lim = Integer(@variable.var_value, 10)
  end

  # GET /universities/1 or /universities/1.json
  def show
    @students = Student.where(university_id: @university.id)
    @nominators = Nominator.where(university_id: @university.id)
  end

  # GET /universities/new
  def new
    @university = University.new
    @university.num_nominees = 0
    @variable = Variable.find_by(var_name: 'max_limit')
    @university.max_limit = Integer(@variable.var_value, 10)
  end

  # GET /universities/1/edit
  def edit; end

  # POST /universities or /universities.json
  def create
    puts
    @university = University.new(university_params)

    respond_to do |format|
      if @university.save
        format.html { redirect_to(universities_path(notice: t('.success'))) }
        format.json { render(:show, status: :created, location: @university) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @university.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /universities/1 or /universities/1.json
  def update
    respond_to do |format|
      if @university.update(university_params)
        format.html { redirect_to(universities_path, notice: t('.success')) }
        format.json { render(:show, status: :ok, location: @university) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @university.errors, status: :unprocessable_entity) }
      end
    end
  end

  # DELETE /universities/1 or /universities/1.json
  def delete
    @university = University.find(params[:id])
  end

  def destroy
    @university.destroy!

    respond_to do |format|
      format.html { redirect_to(universities_url, notice: t('.success')) }
      format.json { head(:no_content) }
    end
  end

  def update_max
    @max_limit = Variable.find_by(var_name: 'max_limit')
    ml = Integer(params[:max_lim], 10)
    if @max_limit.nil?
      @max_limit = Variable.new({ var_name: 'max_limit', var_value: ml })
      @max_limit.save!
    elsif (ml > -1) && (ml < 101)
      @max_limit.var_value = params[:max_lim]
      @max_limit.save!
      redirect_to(universities_path, notice: t('.success'))
    elsif ml.negative?
      redirect_to(universities_path, alert:  t('.neg'))
    elsif ml > 100
      redirect_to(universities_path, alert:  t('.cap'))
      # else
      #   redirect_to universities_path, alert: "There was an error updating max limit."
    end
  end

  def change_all_max
    cl = Integer(params[:change_lim], 10)

    if (cl > -1) && (cl < 101)
      @universities = University.all
      @universities.each do |university|
        university.max_limit = cl
        university.save!
      end
      redirect_to(universities_path, notice: t('.success'))
    elsif cl.negative?
      redirect_to(universities_path, alert:  t('.neg'))
    elsif cl > 100
      redirect_to(universities_path, alert:  t('.cap'))
      # else
      #   redirect_to universities_path, alert: "There was an error updating limits."
    end
  end

  def clear_all
    @universities = University.all
  end

  def destroy_all
    @universities = University.all
    @universities.each(&:destroy)
    # automatically destroys nominators and students
    redirect_to(universities_url, notice: t('.success'))
  end

  def reset_all
    @universities = University.all
  end

  def reset
    @universities = University.all
    @universities.each do |university|
      # delete students too?
      @nominators = Nominator.where(university_id: university.id)
      @nominators.each(&:destroy)
      # nominators auto-destroy students, students auto-destroy responses
      university.num_nominees = 0
      university.save!
    end
    redirect_to(universities_url, notice: t('.success'))
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_university
    @university = University.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def university_params
    params.require(:university).permit(:university_name, :num_nominees, :max_limit)
  end
end
