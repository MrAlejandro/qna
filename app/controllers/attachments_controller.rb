class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    attachment = ActiveStorage::Attachment.find(params[:id])
    resource = attachment&.record

    if resource && current_user.author_of?(resource)
      attachment.purge
    end

    if params[:redirect_url]
      redirect_to params[:redirect_url]
    elsif resource
      redirect_to resource
    else
      redirect_to root_path
    end
  end
end
