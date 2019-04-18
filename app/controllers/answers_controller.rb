class AnswersController < ApplicationController
  before_action :set_answer, only: %i[destroy update best]
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def best
    @question = @answer.question

    if current_user.author_of?(@question)
      unselect_best_answer!(@question.answers)
      @answer.update(best: true)
    end

    render :best
  end

  def destroy
    @answer.destroy if current_user&.author_of?(@answer)
    render :destroy
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def unselect_best_answer!(answers)
    answers.update_all(best: false)
  end
end
