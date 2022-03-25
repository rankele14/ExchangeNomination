class UniversitiesController < ApplicationController
  before_action :set_university, only: %i[ show edit update destroy ]

  # GET /universities or /universities.json
  def index
    @universities = University.all
  end

  # GET /universities/1 or /universities/1.json
  def show
    @students = Student.where(university_id: @university.id)
    @representatives = Representative.where(university_id: @university.id)
  end

  # GET /universities/new
  def new
    @university = University.new
  end

  # GET /universities/1/edit
  def edit
  end

  # POST /universities or /universities.json
  def create
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
  def destroy
    @university.destroy

    respond_to do |format|
      format.html { redirect_to universities_url, notice: "University was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def clear_all
    @universities = University.all
    @universities.each do |university|
      university.destroy
    end
    # automatically destroys representatives and students
  end

  def reset_all
    @universities = University.all
    @universities.each do |university|
      # delete students too?
      @representatives = Representative.where(university_id: university.id)
      @representatives.each do |representative|
        representative.destroy
      end
      @students = Student.where(university_id: university.id)
      @students.each do |student|
        student.destroy
      end
      #responses?
      university.num_nominees = 0
      university.max_limit = $max_limit
      university.save
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_university
      @university = University.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def university_params
      params.require(:university).permit(:university_name, :num_nominees) 
    end
end
