class AnswersController < ApplicationController
  before_action :set_answer, only: %i[destroy update best delete_file]
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
    @answer.mark_as_best! if current_user.author_of?(@question)
  end

  def destroy
    @answer.destroy if current_user&.author_of?(@answer)
  end

  def delete_file
    @file = @answer.delete_file(params[:file_id]) if current_user.author_of?(@answer)
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
