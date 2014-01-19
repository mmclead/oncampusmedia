$(document).ready(function() {

  $('.ambassador_schools input, .school_ambassadors_schools input').change(function() {
    if(this.checked) {
      $(this.parentElement).appendTo($('#current_ambassador_schools .controls'));
    }
    else {
     $(this.parentElement).prependTo($('#non_ambassador_schools .controls')); 
    }
  });

  if($('#included_school_id').val()) {
    $("#ambassador_school_ids_"+$('#included_school_id').val()).attr('checked',true);
    $("#ambassador_school_ids_"+$('#included_school_id').val()).trigger( "change" );
  }
});