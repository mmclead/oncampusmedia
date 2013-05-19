/* Place all the behaviors and hooks related to the matching controller here.
 All this logic will automatically be available in application.js.
 You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
*/

$(document).ready(function() {
  
  $('.school-list-item label').each(function() {
    $(this).attr({'for': this.textContent.trim()} )
  });
  

  $('#start-date.datepicker').datepicker().on('changeDate', function(e){
    $('#end-date.datepicker').datepicker('setStartDate', new Date(e.date.valueOf() + 7*24*60*60*1000))
    $('#end-date.datepicker').datepicker('update', new Date(e.date.valueOf() + 7*24*60*60*1000))
  });
  //$('.quote-button').removeAttr('data-target');
  Gmaps.map.callback = function() {
    
    

    var FullMarkerList = Gmaps.map.markers;
    var CurrentMarkerList = [];
    var DemoList = {
      african_american_black: {name:"african_american_black", min: 0, max: 100}, 
      american_indian_alaskan_native: {name: "american_indian_alaskan_native", min: 0, max: 100}, 
      asian: {name: "asian", min: 0, max: 100}, 
      hispanic_latino: {name: "hispanic_latino", min: 0, max: 100}, 
      native_hawaiian_pacific_islander: {name:"native_hawaiian_pacific_islander", min: 0, max: 100}, 
      non_resident_alien: {name: "non_resident_alien", min: 0, max: 100}, 
      two_or_more_races: {name: "two_or_more_races", min: 0, max: 100}, 
      unknown: {name: "unknown", min: 0, max: 100}, 
      white: {name: "white", min: 0, max: 100},
      average_age: {name:"average_age", min: 0, max: 40}, 
      enrollment: {name: "enrollment", min: 0, max: 10000}
    };
    var StateFilter = [];
    var ConferenceFilter = [];
    var SportFilter = [];

    
    $(".range").each(function() {
      var demo = DemoList[$(this).attr('id')]
      $(this).slider({
        range: true,
        min: demo.min,
        max: demo.max,
        values: [ demo.min, demo.max ],
        slide: function(event, ui) {
          $( "#filtered-"+demo.name ).val( (ui.values[ 0 ])+ " - " + (ui.values[ 1 ]))
          demo.min = ui.values[ 0 ]
          demo.max = ui.values[ 1 ]
          applyFilters()
        }
      });
    });
    
    
    
    $('#state-list input').change(function() {
      $('#all-states input').prop('checked', false);
      StateFilter = [];
      $('#state-list input:checked').map( function() { StateFilter.push(this.name);});
      $('.state-filter-list').html("<span class='badge badge-info'>" + StateFilter.join("</span><span class='badge badge-info'>") + "</span>");
      applyFilters()
    });
    
    $('#all-states input').change(function() {
      if (this.checked) {
        $('#state-list input:checked').prop('checked', false);
        StateFilter = [];
        $('.state-filter-list').text("All States");
        applyFilters()
      }
    });
    
    $('#sport-list input').change(function() {
      $('#all-sports input').prop('checked', false);
      SportFilter = [];
      $('#sport-list input:checked').map( function() { SportFilter.push(this.name);});
      //$('.sport-filter-list').text(SportFilter + "");
      applyFilters()
    });
    
    $('#all-sports input').change(function() {
      if (this.checked) {
        $('#sport-list input:checked').prop('checked', false);
        SportFilter = [];
        $('.sport-filter-list').text("All Sports");
        applyFilters()
      }
    });
    
    $('#conference-list input').change(function() {
      $('#all-conferences input').prop('checked', false);
      ConferenceFilter = $('#conference-list input:checked').map( function() { return this.name;});
      applyFilters()
    });
    
    $('#all-conferences input').change(function() {
      if (this.checked) {
        $('#conference-list input:checked').prop('checked', false);
        ConferenceFilter = [];
        applyFilters()
      }
    });
  
    $('.school-list-item input').change(function() {
      if ($(this).is(':checked')) { addToSelectedList(this) }
      else { removeFromSelectedList(this.value) }
    });
    

    
    var VisibleMarkers = function() {
      var filtered = _.reject(FullMarkerList, function(marker) {
        return !( (_.contains(StateFilter, marker.state) || ($('#all-states input').prop('checked'))) 
        && ( _.some(marker.sports, function(sport) {return _.contains(SportFilter, sport)} ) || ($('#all-sports input').prop('checked')) ) 
        && (_.contains(ConferenceFilter, marker.conference) || ($('#all-conferences input').prop('checked')))
        && (_.every(marker.demographics, function(val, key) { return val >= DemoList[key].min && val <= DemoList[key].max; }))
        );
      });

      return filtered
      
     }

    var applyFilters = function() {
      var markers = VisibleMarkers();
      Gmaps.map.replaceMarkers(markers)
      var list = $('ul.school-list');
      list.text("");
      _.each(markers, function(marker) {
        var li =  $('<li/>')
                  .addClass('school-list-item')
                  .append($('<input/>').attr({type: 'checkbox', 
                                              id: marker.title, 
                                              name: "throw["+marker.title+"]",
                                              value: marker.store_id}))
                  .append( $('<label/>').attr({'for': marker.title}).text(' ' + marker.title + ' - ' + marker.store_id) )
                  .appendTo(list);
        var liline = $('<li/>')
                   .addClass('divider')
                   .appendTo(list);
      });
      
      $('.school-list-item input').change(function() {
        if ($(this).is(':checked')) { addToSelectedList(this) }
        else { removeFromSelectedList(this.value) }
      });
      
      $('i.icon-remove-sign').click(function() {
        removeFromSelectedList(this.id)
      });
    };
    
    var addToSelectedList = function(school) {
      var list = $('ul.selected-list');
      var li =  $('<li/>')
                .addClass('selected-school-item badge badge-info')
                .attr({id: school.value})
                .text(' ' + school.id + ' - ' + school.value + ' ')
                .append($('<input/>').attr({type: 'hidden', 
                                              id: school.id, 
                                              name: "schools["+school.id+"]",
                                              value: school.value}))
                .append($('<i/>').attr({class: 'icon-remove-sign', id: school.value}))
                .appendTo(list);
      $('.quote-button').attr('data-target','#modal').removeClass('disabled'); 
      //$('i.icon-remove-sign').hover(function() {$(this).addClass('icon-white')}, function() {$(this).removeClass('icon-white')});
      $('i.icon-remove-sign').click(function() { removeFromSelectedList(this.id) });
      //$(school.parentElement).add(school.parentElement.nextElementSibling).fadeOut();
    };
    
    var removeFromSelectedList = function(school_id) {
      $('#' + school_id +'.selected-school-item').remove()
      $('input[value='+school_id+']').prop('checked', false);
      var list = $('ul.selected-list');
      if (list.size() == 0) {
        $('.quote-button').attr('data-target','nothing').addClass('disabled'); 
      }
    };
    
  }
});


