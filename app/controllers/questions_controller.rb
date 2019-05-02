class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.links.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def show
    @answer = Answer.new
    @answer.links.new
    @answers = @question.answers.best_first
  end

  def edit
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def destroy
    if current_user&.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Question has been deleted.'
    else
      render :show
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url])
  end
end
