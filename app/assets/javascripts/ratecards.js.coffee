//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/





jQuery ->
        $('#schools').dataTable( {
          "aaSorting": [[ 6, "asc" ]],
          "aoColumnDefs": [ { "sType": "formatted-num", "aTargets": [ 7, 9, 10, 11 ] }]
                            
          "bPaginate": false
        })