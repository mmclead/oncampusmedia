//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/





jQuery ->
        $('#schools').dataTable( {
          "aaSorting": [[ 6, "asc" ]],
          "aoColumnDefs": [ { "sType": "formatted-num", "aTargets": [ 7, 9, 10, 11 ] }]
          "bPaginate": false
          "fnDrawCallback": (oSettings) ->
            $("#schools").data "sortCol", oSettings.aaSorting[0][0]
            $("#schools").data "sortDir", oSettings.aaSorting[0][1]
            $("#pdfLink").attr "href", "#{$('#pdfLink').attr('href').split('?')[0]}?sortCol=#{$('#schools').data('sortCol')}&sortDir=#{$('#schools').data('sortDir')}"

        })