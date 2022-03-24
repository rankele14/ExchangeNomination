class UniversitiesController < ApplicationController
  before_action :set_university, only: %i[ show edit update destroy ]

  # GET /universities or /universities.json
  def index
    @universities = University.all
    @max_lim = $max_limit.to_i
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
    @university.max_limit = $max_limit
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

  def update_max
    #puts "params? #{params[:max_lim]}"
    ml = params[:max_lim].to_i
    if ml > -1
      $max_limit = params[:max_lim].to_i
      redirect_to universities_path, notice: "Max Limit was successfully updated."
    else
      redirect_to universities_path, notice: "Max Limit cannot be negative."
    end
  end

  def change_all_max
    cl = params[:change_lim].to_i

    if cl > -1
      @universities = University.all
      @universities.each do |university|
        university.max_limit = cl
        university.save
      end
      redirect_to universities_path, notice: "Limits were successfully updated."
    else
      redirect_to universities_path, notice: "Limits cannot be negative."
    end
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
