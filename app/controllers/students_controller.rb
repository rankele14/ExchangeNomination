class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy ]

  # GET /students or /students.json
  def index
    @students = Student.all
  end
  
  # this made for possible admin home page
  def admin
  end

  # GET /students/1 or /students/1.json
  def show
    @student = Student.find(params[:id])
    @representative = Representative.find(@student.representative_id)
    @university = University.find(@student.university_id)
  end
  
  # GET /students/1/user_show
  def user_show
    @student = Student.find(params[:id])
    @representative = Representative.find(@student.representative_id)
    @university = University.find(@student.university_id)
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/user_new
  def user_new
    @student = Student.new
    myString2 = String(request.params).tr("^0-9","")
    #if no number passed => error?
    #is parameter "format" important?
    @student.representative_id = params[:id]
    @student.student_email = params[:id]
    @representative = Representative.find(@student.representative_id)
    @student.university_id = @representative.university_id
    @university = University.find(@student.university_id)
    if @university.num_nominees >= 3
      redirect_to finish_url(@representative)
      #format.html { redirect_to finish_url(@university), notice: "Sorry, max limit of 3 students already reached." }
      #format.json { render :show, status: :created, location: @student }
    end
  end

  # GET /students/1/edit
  def edit
  end

  # GET /students/1/user_edit
  def user_edit
    @student = Student.find(params[:id])
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)
    @university = University.find(@student.university_id)

    respond_to do |format|
      if @student.save
        @university.update(num_nominees: @university.num_nominees + 1)
        format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /students but redirects to user_show_student
  def user_create
    @student = Student.new(student_params)
    @university = University.find(@student.university_id)

    respond_to do |format|
      if @student.save
        @university.update(num_nominees: @university.num_nominees + 1)
        format.html { redirect_to user_show_student_url(@student), notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1/user_update
  def user_update
    @student = Student.find(params[:id])
    puts "#Is this working???!! #{@student.first_name}"

    respond_to do |format|
      if @student.user_update(student_params)
        format.html { redirect_to user_show_student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy
    @university = University.find(@student.university_id)
    @university.update(num_nominees: @university.num_nominees - 1)

    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:first_name, :last_name, :university_id, :representative_id, :student_email, :exchange_term, :degree_level, :major)
    end
end
