class StudentResponsesController < ApplicationController
  before_action :set_student_response, only: %i[ show edit update destroy ]

  # GET /student_responses or /student_responses.json
  def index
    @student_responses = StudentResponse.all
  end

  # GET /student_responses/1 or /student_responses/1.json
  def show
  end

  # GET /student_responses/new
  def new
    @student_response = StudentResponse.new
  end

  # GET /student_responses/1/edit
  def edit
  end

  # POST /student_responses or /student_responses.json
  def create
    @student_response = StudentResponse.new(student_response_params)

    respond_to do |format|
      if @student_response.save
        format.html { redirect_to @student_response, notice: "Student response was successfully created." }
        format.json { render :show, status: :created, location: @student_response }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /student_responses/1 or /student_responses/1.json
  def update
    respond_to do |format|
      if @student_response.update(student_response_params)
        format.html { redirect_to @student_response, notice: "Student response was successfully updated." }
        format.json { render :show, status: :ok, location: @student_response }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_responses/1 or /student_responses/1.json
  def destroy
    @student_response.destroy
    respond_to do |format|
      format.html { redirect_to student_responses_url, notice: "Student response was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_response
      @student_response = StudentResponse.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_response_params
      params.require(:student_response).permit(:questionID, :studentID, :response)
    end
end
