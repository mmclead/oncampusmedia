/* Place all the behaviors and hooks related to the matching controller here.
 All this logic will automatically be available in application.js.
 You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
*/

$(document).ready(function() {
  
  //$('.quote-button').removeAttr('data-target');
  Gmaps.map.callback = function() {
    
    

    var FullMarkerList = Gmaps.map.markers;
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
      $('.state-filter-list').text(StateFilter + "");
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
    
    $('.school-list-item input').click(function() {
      if ($('.school-list-item input:checked').size() > 0) {
       // $('.quote-button').attr('data-target','#modal').removeClass('disabled'); 
      }
      else {
       // $('.quote-button').attr('data-target','nothing').addClass('disabled'); 
      }
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
                                              name: "schools["+marker.title+"]",
                                              value: marker.store_id}))
                  .append( $('<label/>').attr({'for': marker.title}).text(' ' + marker.title) )
                  .appendTo(list);
        var liline = $('<li/>')
                   .addClass('divider')
                   .appendTo(list);
      });
    };
  }
});


