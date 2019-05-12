class AnswersController < ApplicationController
  include Voted

  before_action :set_answer, only: %i[destroy update best]
  before_action :authenticate_user!

  after_action :publish_question, only: %i[create]

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

  private

  def publish_question
    return if @answer.errors.any?

    ActionCable.server.broadcast(
        "question_#{@answer.question_id}_answers",
        ApplicationController.render(partial: 'answers/answer.json', locals: { answer: @answer })
    )
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
