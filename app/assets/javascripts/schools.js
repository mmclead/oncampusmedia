/* Place all the behaviors and hooks related to the matching controller here.
 All this logic will automatically be available in application.js.
 You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
*/

$(document).ready(function() {
  
  $('.school-list-item label').each(function() {
    $(this).attr({'for': this.textContent.trim()} )
  });

  $('.school-list').height(function(index, height) {
      return window.innerHeight - ($(this).offset().top + 50);
  }); 
    
  $(window).bind('resize', function() {
    $('.school-list').height(function(index, height) {
      return window.innerHeight - ($(this).offset().top + 50);
    }); 
  });
  
  

  $('#quote-date.datepicker').datepicker().on('changeDate', function(e){
    $('#accept-date.datepicker').datepicker('setStartDate', new Date(e.date.valueOf() + 10*24*60*60*1000))
    $('#accept-date.datepicker').datepicker('update', new Date(e.date.valueOf() + 10*24*60*60*1000))
    $('#start-date.datepicker').datepicker('setStartDate', new Date(e.date.valueOf() + 17*24*60*60*1000))
    $('#start-date.datepicker').datepicker('update', new Date(e.date.valueOf() + 17*24*60*60*1000))
  });
  
  $('#start-date.datepicker').datepicker().on('changeDate', function(e){
    $('#end-date.datepicker').datepicker('setStartDate', new Date(e.date.valueOf() + 7*24*60*60*1000))
    $('#end-date.datepicker').datepicker('update', new Date(e.date.valueOf() + 7*24*60*60*1000))
  });
  
  
  $('.quote-button').removeAttr('data-target');
  
  $('#quote-form').validate();
  
  Gmaps.map.callback = function() {
    
    

    var FullMarkerList = Gmaps.map.markers;
    var CurrentMarkerList = [];
    var DemoList = {
      average_age: {name:"average_age", min: 0, max: 50, percent: 0}, 
      enrollment: {name: "enrollment", min: 0, max: 100000, percent: 0},
      african_american_black: {name:"african_american_black", min: 0, max: 100, percent: 1}, 
      american_indian_alaskan_native: {name: "american_indian_alaskan_native", min: 0, max: 100, percent: 1}, 
      asian: {name: "asian", min: 0, max: 100, percent: 1}, 
      hispanic_latino: {name: "hispanic_latino", min: 0, max: 100, percent: 1}, 
      native_hawaiian_pacific_islander: {name:"native_hawaiian_pacific_islander", min: 0, max: 100, percent: 1}, 
      non_resident_alien: {name: "non_resident_alien", min: 0, max: 100, percent: 1}, 
      two_or_more_races: {name: "two_or_more_races", min: 0, max: 100, percent: 1}, 
      unknown: {name: "unknown", min: 0, max: 100, percent: 1}, 
      white: {name: "white", min: 0, max: 100, percent: 1}
    };

    var StateFilter = [];
    var TypeFilter = [];
    var TermFilter = [];
    var CoffeeFilter = [];
    var ConferenceFilter = [];
    var DMAFilter = [];
    var SportFilter = [];
    var DateFilter = [];

    $('#text-filter').keyup(function(event) {
      if (event.keyCode == 27 || $(this).val() == '') {
        $(this).val('');
        $('.school-list li').removeClass('visible').show().addClass('visible');
      }
      else {
        textFilter('.school-list li', $(this).val());
      }
    });
    
    $(".demo-range").each(function() {
      var demo = DemoList[$(this).attr('id')]
      $(this).slider({
        range: true,
        min: demo.min,
        max: demo.max,
        step: (demo.name == "enrollment") ? 100 : 1,
        values: [ demo.min, demo.max ],
        slide: function(event, ui) {
          if (demo.percent) {
            $( "#filtered-"+demo.name ).val( (ui.values[ 0 ]) + "% - " + (ui.values[ 1 ]) + "%" )
          }
          else { $( "#filtered-"+demo.name ).val( (ui.values[ 0 ]) + " - " + (ui.values[ 1 ]) ) }
          demo.min = ui.values[ 0 ]
          demo.max = ui.values[ 1 ]
        },
        stop: function(event, ui) {
          applyFilters()
        }
      });
    });
    
    $(".trans-range").each(function() {
      $(this).slider({
        range: true,
        step: 100,
        min: 0,
        max: $(this).attr('id').indexOf('total') >= 0 ? 1000000 : 100000,
        values: [0, $(this).attr('id').indexOf('total') >=0 ? 1000000 : 100000 ],
        slide: function(event, ui) {
          $( "#filtered-"+$(this).attr('id') ).val( (ui.values[ 0 ]) + " - " + (ui.values[ 1 ]) )
        },
        stop: function(event, ui) {
          applyFilters()
        }
      });
    });
    
    
    $("#dma-range").slider({
      range: true,
      step: 1,
      min: 0,
      max: 200,
      values: [0, 200],
      slide: function(event, ui) {
        $( "#filtered-dma-rank" ).val( (ui.values[ 0 ]) + " - " + (ui.values[ 1 ]) )
      },
      stop: function(event, ui) {
        applyFilters()
      }
    });
    $("#screen-count-range").slider({
      range: true,
      step: 1,
      min: 0,
      max: 10,
      values: [0, 10],
      slide: function(event, ui) {
        $( "#filtered-screen-count" ).val( (ui.values[ 0 ]) + " - " + (ui.values[ 1 ]) )
      },
      stop: function(event, ui) {
        applyFilters()
      }
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
    
    $('#school-type ul input').change(function() {
      $('#all-types input').prop('checked', false);
      TypeFilter = [];
      $('#school-type ul input:checked').map( function() { TypeFilter.push(this.name);});
      applyFilters()
    });
    
    $('#all-types input').change(function() {
      if (this.checked) {
        $('#school-type ul input:checked').prop('checked', false);
        TypeFilter = [];
        applyFilters()
      }
    });

    $('#term ul input').change(function() {
      $('#all-terms input').prop('checked', false);
      TermFilter = [];
      $('#term ul input:checked').map( function() { TermFilter.push(this.value);});
      applyFilters()
    });
    
    $('#all-terms input').change(function() {
      if (this.checked) {
        $('#term ul input:checked').prop('checked', false);
        TermFilter = [];
        applyFilters()
      }
    });
    
    $('#coffee-station ul input').change(function() {
      $('#all-coffee input').prop('checked', false);
      CoffeeFilter = [];
      $('#coffee-station ul input:checked').map( function() { CoffeeFilter.push(this.name);});
      applyFilters()
    });
    
    $('#all-coffee input').change(function() {
      if (this.checked) {
        $('#coffee-station ul input:checked').prop('checked', false);
        CoffeeFilter = [];
        applyFilters()
      }
    });
    
    
    $('#store-hours ul input').change(function() {
      $('#all-hours input').prop('checked', false);
      HoursFilter = [];
      $('#store-hours ul input:checked').map( function() { HoursFilter.push(this.name);});
      applyFilters()
    });
    
    $('#all-hours input').change(function() {
      if (this.checked) {
        $('#store-hours ul input:checked').prop('checked', false);
        HoursFilter = [];
        applyFilters()
      }
    });
    
    $('#rotc ul input').change(function() {
      $('#all-rotc input').prop('checked', false);
      ROTCFilter = [];
      $('#rotc ul input:checked').map( function() { ROTCFilter.push(this.value);});
      applyFilters()
    });
    
    $('#all-rotc input').change(function() {
      if (this.checked) {
        $('#rotc ul input:checked').prop('checked', false);
        ROTCFilter = [];
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
  
    $('#dma-list input').change(function() {
      $('#all-dma input').prop('checked', false);
      DMAFilter = $('#dma-list input:checked').map( function() { return this.name;});
      applyFilters()
    });
    
    $('#all-dma input').change(function() {
      if (this.checked) {
        $('#dma-list input:checked').prop('checked', false);
        DMAFilter = [];
        applyFilters()
      }
    });
    
    $('#schedule ul input').change(function() {
      $('#all-schedules input').prop('checked', false);
      DateFilter = $('#schedule ul input').map( function() { if($(this).val()) {return $(this)} });
      applyFilters()
    });
    
    $('#all-schedules input').change(function() {
      if (this.checked) {
        $('#schedule ul input').val('');
        DateFilter = [];
        applyFilters()
      }
    });
    
    $('.school-list-item input').change(function() {
      if ($(this).is(':checked')) { addToSelectedList(this) }
      else { removeFromSelectedList(this.value) }
    });

    
    var VisibleMarkers = function() {
      var filtered = _.reject(FullMarkerList, function(marker) {
        return !( 
           (($('#all-states input').prop('checked')) || (_.contains(StateFilter, marker.state) ))
        && (($('#all-types input').prop('checked')) || (_.contains(TypeFilter, marker.store_info.school_type) ))
        && (($('#all-terms input').prop('checked')) || (_.contains(TermFilter, marker.schedule.term) ))
        && (($('#all-coffee input').prop('checked')) || ( _.some(marker.store_info.coffee, function(coffee) {return _.contains(CoffeeFilter, coffee)})) )
        && (($('#all-hours input').prop('checked')) || ( _.every(HoursFilter, function(day) {return marker.store_info.hours[day]  > 0 })) )
        && (($('#all-sports input').prop('checked')) || ( _.some(marker.sports, function(sport) {return _.contains(SportFilter, sport)})) ) 
        && (($('#all-conferences input').prop('checked')) || (_.contains(ConferenceFilter, marker.conference)) )
        && (($('#all-dma input').prop('checked')) || (_.contains(DMAFilter, marker.store_info.dma.dma)) )
        && (($('#all-rotc input').prop('checked')) || (_.contains(ROTCFilter, marker.store_info.rotc.toString())) )
        && ( marker.store_info.dma.dma_rank >= $('#dma-range').slider("values", 0) && marker.store_info.dma.dma_rank <= $('#dma-range').slider("values", 1) )
        && ( marker.store_info.screen_count >= $('#screen-count-range').slider("values", 0) && marker.store_info.screen_count <= $('#screen-count-range').slider("values", 1) )
        && (_.every(marker.demographics, function(val, key) { return val ? val >= DemoList[key].min && val <= DemoList[key].max : true }))
        && (_.every(marker.transactions, function(val, key) { return val >= $('#'+key.toLowerCase()).slider("values", 0) && val <= $('#'+key.toLowerCase()).slider("values", 1); }))
        && (($('#all-schedules input').prop('checked')) || _.every(DateFilter, function(date) { return  ($(date).val() ? 
            ($(date).attr('id').indexOf('start') >= 0 ? 
              new Date($(date).val()) <= new Date(marker.schedule.dates[$(date).attr('id').substring(0,$(date).attr('id').length-6)]) : 
              new Date($(date).val()) >= new Date(marker.schedule.dates[$(date).attr('id').substring(0,$(date).attr('id').length-4)])) :
            true ) } ) )
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
      $('#total-schools').text(markers.length + ' schools');
      
      
      
      $('.school-list-item input').change(function() {
        if ($(this).is(':checked')) { addToSelectedList(this) }
        else { removeFromSelectedList(this.value) }
      });
      $('#select-all-schools').removeClass('hidden');
      $('#select-all-schools input').change(function() {
        if (this.checked) {
          $('.school-list-item input').each(function() {
            $(this).prop('checked', true);
            addToSelectedList(this);
          });
          $(this).prop('checked', false)
        }
      });
      
      $('i.icon-remove-sign').click(function() {
        removeFromSelectedList(this.id)
      });
    };
    
    
    //filter schools based on query
    var textFilter = function(selector, query) {
      query	=	$.trim(query); //trim white space
      query = query.replace(/ /gi, '|'); //add OR for regex query
    
      $(selector).each(function() {
        ($(this).text().search(new RegExp(query, "i")) < 0) ? $(this).add($(this).nextSibling).hide().removeClass('visible') : $(this).add($(this).nextSibling).show().addClass('visible');
      });
    };
    
    var addToSelectedList = function(school) {
      if ($('#'+school.value + '.selected-school-item').size() == 0) {
        var list = $('ul.selected-list');
        var li =  $('<li/>')
                  .addClass('selected-school-item badge badge-info')
                  .attr({id: school.value})
                  .text(' ' + school.id + ' - ' + school.value + ' ')
                  .append($('<input/>').attr({type: 'hidden', 
                                                id: school.id, 
                                                name: "schools["+school.id+"]",
                                                value: school.value}))
                  .append($('<i/>').attr({class: 'icon-remove-sign pull-right', id: school.value}))
                  .appendTo(list);
        $('#school-count').text($('.selected-school-item').size() + ' selected')
        $('.quote-button').attr('data-target','#modal').removeClass('disabled'); 
        $('i.icon-remove-sign').click(function() { removeFromSelectedList(this.id) });
      }
    };
    
    var removeFromSelectedList = function(school_id) {
      $('#' + school_id +'.selected-school-item').remove()
      $('input[value='+school_id+']').prop('checked', false);
      if ($('.selected-school-item').size() == 0) {
        $('.quote-button').attr('data-target','nothing').addClass('disabled'); 
      }
      $('#school-count').text($('.selected-school-item').size() + ' selected')

    };
    
  }
});


