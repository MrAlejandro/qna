class AnswersController < ApplicationController
  before_action :set_answer, only: %i[destroy update]
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if current_user&.author_of?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Answer has been deleted.'
    else
      redirect_to @answer.question, notice: 'You have to be the owner of the question to delete it.'
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
