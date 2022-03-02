class AnswerChoicesController < ApplicationController
  before_action :set_answer_choice, only: %i[ show edit update destroy ]

  # GET /answer_choices or /answer_choices.json
  def index
    @answer_choices = AnswerChoice.all
  end

  # GET /answer_choices/1 or /answer_choices/1.json
  def show
  end

  # GET /answer_choices/new
  def new
    @answer_choice = AnswerChoice.new
  end

  # GET /answer_choices/1/edit
  def edit
  end

  # POST /answer_choices or /answer_choices.json
  def create
    @answer_choice = AnswerChoice.new(answer_choice_params)

    respond_to do |format|
      if @answer_choice.save
        format.html { redirect_to @answer_choice, notice: "Answer choice was successfully created." }
        format.json { render :show, status: :created, location: @answer_choice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @answer_choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /answer_choices/1 or /answer_choices/1.json
  def update
    respond_to do |format|
      if @answer_choice.update(answer_choice_params)
        format.html { redirect_to @answer_choice, notice: "Answer choice was successfully updated." }
        format.json { render :show, status: :ok, location: @answer_choice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @answer_choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answer_choices/1 or /answer_choices/1.json
  def destroy
    @answer_choice.destroy
    respond_to do |format|
      format.html { redirect_to answer_choices_url, notice: "Answer choice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer_choice
      @answer_choice = AnswerChoice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def answer_choice_params
      params.require(:answer_choice).permit(:questionID, :anser_choice)
    end
end
