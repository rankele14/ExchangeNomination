class UniversitiesController < ApplicationController
  before_action :set_university, only: %i[ show edit update destroy ]

  # GET /universities or /universities.json
  def index
    @universities = University.all
    @variable = Variable.find_by(var_name: 'max_limit')
    @max_lim = @variable.var_value.to_i
  end

  # GET /universities/1 or /universities/1.json
  def show
    @students = Student.where(university_id: @university.id)
    @representatives = Representative.where(university_id: @university.id)
  end

  # GET /universities/new
  def new
    @university = University.new
    @university.num_nominees = 0
    @variable = Variable.find_by(var_name: 'max_limit')
    @university.max_limit = @variable.var_value.to_i
  end

  # GET /universities/1/edit
  def edit
  end

  # POST /universities or /universities.json
  def create
    puts
    @university = University.new(university_params)

    respond_to do |format|
      if @university.save
        format.html { redirect_to universities_path notice: "University was successfully created." }
        format.json { render :show, status: :created, location: @university }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @university.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /universities/1 or /universities/1.json
  def update
    respond_to do |format|
      if @university.update(university_params)
        format.html { redirect_to universities_path, notice: "University was successfully updated." }
        format.json { render :show, status: :ok, location: @university }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @university.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /universities/1 or /universities/1.json
  def delete
    @university = University.find(params[:id])
  end

  def destroy
    @university.destroy

    respond_to do |format|
      format.html { redirect_to universities_url, notice: "University was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def update_max
    @variable = Variable.find_by(var_name: 'max_limit')
    #puts "params? #{params[:max_lim]}"
    ml = params[:max_lim].to_i
    if ml > -1 and ml < 101
      @variable.var_value = params[:max_lim]
      @variable.save
      redirect_to universities_path, notice: "Max Limit was successfully updated."
    elsif ml < 0
      redirect_to universities_path, alert: "There was an error updating max limit. Max Limit cannot be negative."
    elsif ml > 100
      redirect_to universities_path, alert: "There was an error updating max limit. Max Limit capped at 100."
    else
      redirect_to universities_path, alert: "There was an error updating max limit."
    end
  end

  def change_all_max
    cl = params[:change_lim].to_i

    if cl > -1 and cl < 101
      @universities = University.all
      @universities.each do |university|
        university.max_limit = cl
        university.save
      end
      redirect_to universities_path, notice: "Limits were successfully updated."
    elsif cl < 0
      redirect_to universities_path, alert: "There was an error updating limits. Limits cannot be negative."
    elsif cl > 100
      redirect_to universities_path, alert: "There was an error updating limits. Limits capped at 100."
    else
      redirect_to universities_path, alert: "There was an error updating limits."
    end
  end

  def clear_all
    @universities = University.all
  end

  def destroy_all
    @universities = University.all
    @universities.each do |university|
      university.destroy
    end
    # automatically destroys representatives and students
    redirect_to universities_url, notice: "Universities successfully cleared."
  end

  def reset_all
    @universities = University.all
    @universities.each do |university|
      # delete students too?
      @representatives = Representative.where(university_id: university.id)
      @representatives.each do |representative|
        representative.destroy
      end
      # representatives auto-destroy students, students auto-destroy responses
      university.num_nominees = 0
      university.save
    end
    redirect_to universities_url, notice: "Universities successfully reset."
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
