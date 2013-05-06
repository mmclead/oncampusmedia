/* Place all the behaviors and hooks related to the matching controller here.
 All this logic will automatically be available in application.js.
 You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
*/

$(document).ready(function() {
  Gmaps.map.callback = function() {

    var FullMarkerList = Gmaps.map.markers
    var StateFilter = [];
    var CountFilter = {
      min: 0,
      max: 2,
    };
  
    $("#school-count-range").slider({
      range: true,
      min: CountFilter.min,
      max: CountFilter.max,
      values: [ CountFilter.min, CountFilter.max ],
      slide: function(event, ui) {
        $( "#filtered-pop" ).val( (ui.values[ 0 ])+ " - " + (ui.values[ 1 ]))
        CountFilter.min = ui.values[ 0 ]
        CountFilter.max = ui.values[ 1 ]
        applyFilters()
      }
    });
    
    $('#state-list input').change(function() {
      $('#all-states input').prop('checked', false);
      StateFilter = $('#state-list input:checked').map( function() { return this.name;});
      applyFilters()
    });
    
    $('#all-states input').change(function() {
      if (this.checked) {
        $('#state-list input:checked').prop('checked', false);
        StateFilter = [];
        applyFilters()
      }
    });
    
    
    var VisibleMarkers = function() {
      var filtered = _.reject(FullMarkerList, function(marker) {
        return (!(_.contains(StateFilter, marker.state)) && !($('#all-states input').prop('checked')) );
      });

      return filtered
      
     }

    var applyFilters = function() {
      Gmaps.map.replaceMarkers(VisibleMarkers())
      //_.each(Gmaps.map.markers, function(marker) {
      //  Gmaps.map.hideMarker(marker)
      //})
      //Gmaps.map.markerClusterer.clearMarkers()
      //_.each(VisibleMarkers(), function(marker) {
      //  Gmaps.map.showMarker(marker)
        //Gmaps.map.markerClusterer.addMarker(marker)
      //})
    };
  }
});


