$(document).ready(function() {
  $('.add-new-link a')
    .data('association-insertion-method', 'append')
    .data('association-insertion-node', function(link){
      return link.parent().siblings('.links-form');
    });
});
