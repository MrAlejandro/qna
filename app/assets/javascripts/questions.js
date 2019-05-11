$(document).on('turbolinks:load', function () {
  $('.question').on('click', '.edit-question-link', function (e) {
    e.preventDefault();
    $(this).hide();
    $('#edit_question_form').show();
  });

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function () {
      this.perform('follow');
    },

    received: function (data) {
      var question = JSON.parse(data);

      $('.questions-list').append(
        JST['templates/question'](question)
      );
    },
  });

  App.cable.subscriptions.create('CommentsChannel', {
    connected: function () {
      this.perform('follow', {resource: 'question', id: gon.question_id});
    },

    received: function (data) {
      var comment = JSON.parse(data);

      $('.question-comments').find('.comments').append(
        JST['templates/comment'](comment)
      );
    },
  });
});
