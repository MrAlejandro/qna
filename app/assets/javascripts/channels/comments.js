$(document).on('turbolinks:load', function () {
  App.cable.subscriptions.create('CommentsChannel', {
    connected: function () {
      if (!gon.question_id) {
        return;
      }

      this.perform('follow', {resource: 'question', id: gon.question_id});
    },

    received: function (data) {
      var comment = JSON.parse(data),
        commentableType = comment.commentable_type.toLowerCase();

      if (comment.author_id === gon.user_id) {
        return;
      }

      var $container = $('#' + commentableType + '_' + comment.commentable_id)
        .find('.' + commentableType + '-comments')
        .find('.comments');

      $container.append(JST['templates/comment'](comment));
    },
  });
});
