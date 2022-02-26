class RepresentativesController < ApplicationController
  before_action :set_representative, only: %i[ show edit update destroy ]

  # GET /representatives or /representatives.json
  def index
    @representatives = Representative.all
  end

  # GET /representatives/1 or /representatives/1.json
  def show
  end

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
  def edit
  end

  # GET /representatives/1/user_edit
  def user_edit
    @representative = Representative.find(params[:id])
  end

  # POST /representatives or /representatives.json
  def create
    @representative = Representative.new(representative_params)

    respond_to do |format|
      if @representative.save
        format.html { redirect_to representative_url(@representative), notice: "Representative was successfully created." }
        format.json { render :show, status: :created, location: @representative }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @representative.errors, status: :unprocessable_entity }
      end
    end
  end

  def user_create
    @representative = Representative.new(representative_params)

    respond_to do |format|
      if @representative.save
        format.html { redirect_to user_show_representative_url(@representative), notice: "Representative was successfully created." }
        format.json { render :show, status: :created, location: @representative }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @representative.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /representatives/1 or /representatives/1.json
  def update
    respond_to do |format|
      if @representative.update(representative_params)
        format.html { redirect_to representative_url(@representative), notice: "Representative was successfully updated." }
        format.json { render :show, status: :ok, location: @representative }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @representative.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /representatives/1 or /representatives/1.json
  def update
    respond_to do |format|
      if @representative.update(representative_params)
        format.html { redirect_to representative_url(@representative), notice: "Representative was successfully updated." }
        format.json { render :show, status: :ok, location: @representative }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @representative.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /representatives/1 or /representatives/1.json
  def destroy
    @representative.destroy

    respond_to do |format|
      format.html { redirect_to representatives_url, notice: "Representative was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def finish
    @representative = Representative.find(params[:id])
    @students = Student.where(representative_id: @representative.id)
  end

  def rep_check
    @representative = Representative.find(params[:id])
    @university = University.find(@representitive.university_id)

    if @university.num_nominees >= 3
      format.html { redirect_to finish_representative_url, notice: "University nominees already reached max limit of 3 students." }
    else
      @student = Student.new
      @student.update(first_name: "", last_name: "", university_id: @representitive.university_id, student_email: "", exchange_term: "", degree_level: "", major: "")
      edit_student_path(@student)
    end
  end

  def test_method
    @representative.update(first_name: "Updated")
  end

  def rep_redirect
    user_new_student_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_representative
      @representative = Representative.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def representative_params
      params.require(:representative).permit(:first_name, :last_name, :title, :university_id,:rep_email)
    end
end
