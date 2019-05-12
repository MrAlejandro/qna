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

      if (answer.author_id === gon.user_id) {
        return;
      }

      $('#question_' + answer.question_id).find('.answers').append(
        JST['templates/answer'](answer)
      );
    },
  });
});
