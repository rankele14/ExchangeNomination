require 'common_stuff'
class NominatorsController < ApplicationController
  include CommonStuff
  before_action :set_nominator, only: %i[ show edit update destroy ]

  # GET /nominators or /nominators.json
  def index
    @nominators = Nominator.all
  end

  # GET /nominators/1 or /nominators/1.json
  def show
    @students = Student.where(nominator_id: @nominator.id)
  end

  # GET /nominators/1/user_show
  def user_show
    @nominator = Nominator.find(params[:id])
  end

  # GET /nominators/new
  def new
    @nominator = Nominator.new
  end

  # GET /nominators/user_new
  def user_new
    @nominator = Nominator.new
    @deadline = Variable.find_by(var_name: 'deadline')
    if @deadline != nil && Time.now > @deadline.var_value # past the deadline
      redirect_to deadline_dashboards_path 
    end
  end

  # GET /nominators/1/edit
  def edit
  end

  # GET /nominators/1/user_edit
  def user_edit
    @nominator = Nominator.find(params[:id])
  end

  # POST /nominators or /nominators.json
  def create
    @nominator = Nominator.new(nominator_params)

    respond_to do |format|
      if @nominator.save
        format.html { redirect_to nominator_url(@nominator), notice: "Nominator was successfully created." }
        format.json { render :show, status: :created, location: @nominator }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @nominator.errors, status: :unprocessable_entity }
      end
    end
  end

  def user_create
    @nominator = Nominator.new(nominator_params)
    @deadline = Variable.find_by(var_name: 'deadline')
    if @deadline != nil && Time.now > @deadline.var_value then # past the deadline
      redirect_to deadline_dashboards_path 
    else
      respond_to do |format|
        if @nominator.save
          format.html { redirect_to user_show_nominator_url(@nominator), notice: "Nominator was successfully created." }
          format.json { render :show, status: :created, location: @nominator }
        else
          format.html { render :user_new, status: :unprocessable_entity }
          format.json { render json: @nominator.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /nominators/1 or /nominators/1.json
  def update
    @uni_prev = University.find(@nominator.university_id)
    respond_to do |format|
      if @nominator.update(nominator_params)
        @university = University.find(@nominator.university_id)
        if @uni_prev != @university
          @students = Student.where(nominator_id: @nominator.id)
          @students.each do |student|
            student.university_id = @nominator.university_id
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
        format.html { redirect_to nominator_url(@nominator), notice: "Nominator was successfully updated." }
        format.json { render :show, status: :ok, location: @nominator }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @nominator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nominators/1 or /nominators/1.json
  def user_update
    @nominator = Nominator.find(params[:id])
    @deadline = Variable.find_by(var_name: 'deadline')

    if @deadline != nil && Time.now > @deadline.var_value then # past the deadline
      redirect_to finish_nominator_url(@nominator), alert: "Sorry, the deadline for submitting students has passed" 
    else
      respond_to do |format|
        if @nominator.update(nominator_params)
          format.html { redirect_to user_show_nominator_url(@nominator), notice: "Nominator was successfully updated." }
          format.json { render :show, status: :ok, location: @nominator }
        else
          format.html { render :user_edit, status: :unprocessable_entity }
          format.json { render json: @nominator.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /nominators/1 or /nominators/1.json
  def delete
    @nominator = Nominator.find(params[:id])
  end

  def destroy
    @students = Student.where(nominator_id: @nominator.id)
    @students.each do |student|
      destroy_uni_update(student.id)
    end
    @nominator.destroy

    respond_to do |format|
      format.html { redirect_to nominators_url, notice: "Nominator was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def finish
    @nominator = Nominator.find(params[:id])
    @students = Student.where(nominator_id: @nominator.id)
    @university = University.find(@nominator.university_id)
    @deadline = Variable.find_by(var_name: 'deadline')
  end

  def test_method
    @nominator.update(first_name: "Updated")
  end

  def nominator_redirect
    user_new_student_path
  end

  def clear_all
    @nominators = Nominator.all
  end

  def destroy_all
    @nominators = Nominator.all
    @nominators.each do |nominator|      
      @students = Student.where(nominator_id: nominator.id)
      @students.each do |student|
        destroy_uni_update(student.id)
      end
      nominator.destroy
    end
    # automatically destroys rep's students
    redirect_to nominators_url, notice: "Nominators successfully cleared."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nominator
      @nominator = Nominator.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def nominator_params
      params.require(:nominator).permit(:first_name, :last_name, :title, :university_id,:nominator_email)
    end
end
