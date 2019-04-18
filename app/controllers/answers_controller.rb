class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question
    else
      @question.reload
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user&.author_of?(@answer)
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
