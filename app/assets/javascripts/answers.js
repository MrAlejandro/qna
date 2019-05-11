$(document).on('turbolinks:load', function () {
  $('.answers').on('click', '.edit-answer-link', function (e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit_answer_' + answerId).show();
  });

  App.cable.subscriptions.create('AnswersChannel', {
    connected: function () {
      if (!gon.question_id) {
        return;
      }

      this.perform('follow', { question_id: gon.question_id });
    },

    received: function (data) {
      var answer = JSON.parse(data);

      $('#question_' + answer.question_id).find('.answers').append(
        JST['templates/answer'](answer)
      );
    },
  });

  App.cable.subscriptions.create('CommentsChannel', {
    connected: function () {
      if (gon.answer_ids.lentgh === 0) {
        return;
      }

      for (var answer_id of gon.answer_ids) {
        this.perform('follow', {resource: 'answer', id: answer_id});
      }
    },

    received: function (data) {
      var comment = JSON.parse(data);

      if (comment.commentable_type !== 'Answer') {
        return;
      }

      var $container = $('#answer_' + comment.commentable_id)
        .find('.answer-comments')
        .find('.comments');

      $container.append(JST['templates/comment'](comment));
    },
  });
});
