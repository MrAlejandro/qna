class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    link = Link.find(params[:id])
    resource = link.linkable

    if resource && current_user.author_of?(resource)
      link.destroy
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
