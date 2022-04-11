require 'csv'
require 'common_stuff'
class StudentsController < ApplicationController
  include CommonStuff
  before_action :set_student, only: %i[ show user_show edit user_edit update user_update destroy user_destroy delete user_delete ]

  # GET /students or /students.json
  def index
    @students = Student.all
  end
  
  # this made for possible admin home page
  def admin
    @deadline = Variable.find_by(var_name: 'deadline')
    if @deadline == nil
      @deadline = Variable.new
    end

    @variable = Variable.find_by(var_name: 'max_limit')
    if @variable == nil
      @variable = Variable.new({var_name: 'max_limit', var_value: 3})
      @variable.save
    end
  end

  # GET /students/1 or /students/1.json
  def show
    @representative = Representative.find(@student.representative_id)
    @university = University.find(@student.university_id)
  end
  
  # GET /students/1/user_show
  def user_show
    @representative = Representative.find(@student.representative_id)
    @university = University.find(@student.university_id)
    @variable = Variable.find_by(var_name: 'max_limit')
    @deadline = Variable.find_by(var_name: 'deadline')
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/user_new
  def user_new
    @student = Student.new
    @student.representative_id = params[:id]
    @representative = Representative.find(params[:id])
    @student.university_id = @representative.university_id
    @university = University.find(@student.university_id)
    @deadline = Variable.find_by(var_name: 'deadline')

    # if @university.num_nominees >= @university.max_limit
    #   redirect_to finish_representative_url(@representative), alert: "Sorry, maximum limit of 3 students already reached." 
    # elsif @deadline != nil && Time.now > @deadline.var_value then # past the deadline
    #   redirect_to finish_representative_path(@representative), alert: "Sorry, the deadline for submitting students has passed" 
    # end
  end

  # GET /students/1/edit
  def edit
  end

  # GET /students/1/user_edit
  def user_edit
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
	    Question.all.each do |question|
          @response = Response.new(student_id: @student.id)
          @response.question_id = question.id
          @response.save
        end
        @university = University.find(@student.university_id)
        if @student.exchange_term.include? 'and'
          @university.update(num_nominees: @university.num_nominees + 2)
        else
          @university.update(num_nominees: @university.num_nominees + 1)
        end
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
    @representative = Representative.find(@student.representative_id)
    @university = University.find(@student.university_id)
    @deadline = Variable.find_by(var_name: 'deadline')
    
    if @deadline != nil && Time.now > @deadline.var_value then# past the deadline
      redirect_to finish_representative_path(@student.representative_id), alert: "Sorry, the deadline for submitting students has passed" 
    else
      respond_to do |format|
        if @student.save
		  Question.all.each do |question|
            @response = Response.new(student_id: @student.id)
            @response.question_id = question.id
            @response.save
          end
          if @student.exchange_term.include? 'and'
            @university.update(num_nominees: @university.num_nominees + 2)
          else
            @university.update(num_nominees: @university.num_nominees + 1)
          end
          ConfirmationMailer.with(student: @student, representative: Representative.find_by(id: @student.representative_id)).confirm_email.deliver_later
          format.html { redirect_to user_show_student_url(@student), notice: "Student was successfully created." }
          format.json { render :show, status: :created, location: @student }
        else
          format.html { render :user_new, status: :unprocessable_entity }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  # PATCH/PUT /students/1 or /students/1.json
  def update
    prev_term = @student.exchange_term
    new_term = params[:student][:exchange_term]
    @university = University.find(@student.university_id)
    @variable = Variable.find_by(var_name: 'max_limit')

    if !(prev_term.include? 'and') && (new_term.include? 'and') && (@university.num_nominees >= @university.max_limit) then # used to be single, now double, exceeds university limit
      redirect_to edit_student_url(@student), alert: "Sorry, a double term nomination would exceed the university's nomination limit. Please stick to a single term nomination." 
    else
      respond_to do |format|
        if @student.update(student_params)
          if !(prev_term.include? 'and') && (new_term.include? 'and') then # used to be single, now double
            @university.update(num_nominees: @university.num_nominees + 1)
          elsif (prev_term.include? 'and') && !(new_term.include? 'and') then # used to be double, now single
            @university.update(num_nominees: @university.num_nominees - 1)
          end
          format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
          format.json { render :show, status: :ok, location: @student }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /students/1/user_update
  def user_update
    prev_term = @student.exchange_term
    new_term = params[:student][:exchange_term]
    @university = University.find(@student.university_id)
    @deadline = Variable.find_by(var_name: 'deadline')

    if !(prev_term.include? 'and') && (new_term.include? 'and') && (@university.num_nominees >= @university.max_limit) then # used to be single, now double, exceeds university limit
      redirect_to user_edit_student_url(@student), alert: "Sorry, a double term nomination would exceed the university's nomination limit. Please stick to a single term nomination." 
    elsif @deadline != nil && Time.now > @deadline.var_value then # past the deadline
      redirect_to finish_representative_path(@student.representative_id), alert: "Sorry, the deadline for submitting students has passed" 
    else
      respond_to do |format|
        if @student.update(student_params)
          if !(prev_term.include? 'and') && (new_term.include? 'and') then # used to be single, now double
            @university.update(num_nominees: @university.num_nominees + 1)
          elsif (prev_term.include? 'and') && !(new_term.include? 'and') then # used to be double, now single
            @university.update(num_nominees: @university.num_nominees - 1)
          end
          format.html { redirect_to user_show_student_url(@student), notice: "Student was successfully updated." }
          format.json { render :show, status: :ok, location: @student }
        else
          format.html { render :user_edit, status: :unprocessable_entity }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def delete
    @university = University.find_by(id: @student.university_id)
  end

  def destroy
    destroy_uni_update(@student.id)
	Response.all.each do |response|
	  if @student.id == response.student_id then
		response.destroy
	  end
	end
    @student.destroy

    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully removed." }
      format.json { head :no_content }
    end
  end

  def user_delete
    @university = University.find_by(id: @student.university_id)
  end

  def user_destroy
    @representative = Representative.find(@student.representative_id)
    @deadline = Variable.find_by(var_name: 'deadline')
    if @deadline != nil && Time.now > @deadline.var_value then
      respond_to do |format|
        format.html { redirect_to finish_representative_path(@representative), notice: "Sorry, the deadline for removing students has passed." }
        format.json { head :no_content }
      end
    else
      @representative = Representative.find(@student.representative_id)
      destroy_uni_update(@student.id)
      Response.all.each do |response|
	      if @student.id == response.student_id then
		      response.destroy
	      end
	    end
      @student.destroy

      respond_to do |format|
        format.html { redirect_to finish_representative_path(@representative), notice: "Student was successfully removed." }
        format.json { head :no_content }
      end
    end
  end
  
  def export
    @students = Student.all
    @students = @students.sort_by(&:university_id)
    @questions = Question.all
    @responses = Response.all

    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=student.csv"
      end
    end
  end

  def update_deadline
    @deadline = Variable.find_by(var_name: 'deadline')
    deadline = params[:deadline]
    if @deadline == nil
      @deadline = Variable.new({var_name: 'deadline', var_value: deadline})
    else
      @deadline.var_value = deadline
    end
    @deadline.save
    redirect_to admin_url, notice: "Deadline was successfully updated."
  end


  def clear_all
    @students = Student.all
  end

  def destroy_all
    @students = Student.all
    @students.each do |student|
      destroy_uni_update(student.id)
      student.destroy
    end
    # automatically destroys responses
    redirect_to students_url, notice: "Students successfully cleared."
  end
  
  # help pages
  def admin_help
  end

  def user_help
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
