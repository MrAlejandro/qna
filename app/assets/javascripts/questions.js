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

      if (question.author_id === gon.user_id) {
        return;
      }

      $('.questions-list').append(
        JST['templates/question'](question)
      );
    },
  });
});
