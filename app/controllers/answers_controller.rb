class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    current_user.answers << @answer
    current_user.save

    redirect_to @question, notice: @answer.errors.full_messages.join(', ')
  end

  def destroy
    @answer = Answer.find(params[:id])

    if @answer.author?(current_user)
      @answer.destroy
      redirect_to @answer.question, notice: 'Answer has been deleted.'
    else
      redirect_to @answer.question, notice: 'You have to be the owner of the question to delete it.'
    end

  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
