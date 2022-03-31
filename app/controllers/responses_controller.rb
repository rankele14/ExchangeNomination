class ResponsesController < ApplicationController
  before_action :set_response, only: %i[ show edit update destroy ]
  before_action :get_student
  # GET /responses or /responses.json
  def index
    @responses = @student.response
  end

  # GET /responses/1 or /responses/1.json
  def show
  end

  # GET /responses/new
  def new
    @response = @student.response.build
  end

  # GET /responses/1/edit
  def edit
  end

  # POST /responses or /responses.json
  def create
	@questions = Question
    @response = @student.response.build(response_params)

    respond_to do |format|
      if @response.save
        format.html { redirect_to new_student_response_path(@student), notice: "Response was successfully created." }
        format.json { render :show, status: :created, location: @response }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /responses/1 or /responses/1.json
  def update
    respond_to do |format|
      if @response.update(response_params)
        format.html { redirect_to student_responses_path(@student), notice: "Response was successfully updated." }
        format.json { render :show, status: :ok, location: @response }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /responses/1 or /responses/1.json
  def delete
    @response = Response.find(params[:id])
  end

  def destroy
    @response.destroy
    respond_to do |format|
      format.html { redirect_to student_responses_path(@student), notice: "Response was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
	def get_student
	  @student = Student.find(params[:student_id])
	end
    # Use callbacks to share common setup or constraints between actions.
    def set_response
      @response = Student.find(params[:student_id]).response.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def response_params
      params.require(:response).permit(:reply, :question_id, :student)
    end
end
