//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$('.school-table tr').hover (function(){
  $(this).append($('<td/>')
  .append($('<i/>').attr({class: 'icon-remove-sign pull-right'})))
  
  
}); 
