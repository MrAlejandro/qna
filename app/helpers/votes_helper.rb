module VotesHelper
  def upvote_link(resource)
    link_to 'Up vote',
             send("upvote_#{resource_name(resource)}_path", resource, format: :json),
             method: :post,
             remote: true,
             data: { target_id: "vote_for_#{resource.class}_#{resource.id}" }
  end

  def downvote_link(resource)
    link_to 'Down vote',
            send("downvote_#{resource_name(resource)}_path", resource, format: :json),
            method: :post,
            remote: true,
            data: { target_id: "vote_for_#{resource.class}_#{resource.id}" }
  end

  private

  def resource_name(resource)
    resource.class.to_s.underscore
  end
end
