$(function(){

  var $container = $('#grid-filter-items');

  $container.isotope({
    itemSelector : '.isotope-item'
  });
  
  $container.infinitescroll({
    navSelector  : '#page_nav',    // selector for the paged navigation 
    nextSelector : '#page_nav a',  // selector for the NEXT link (to page 2)
    itemSelector : '.isotope-item',     // selector for all items you'll retrieve
    loading: {
        finishedMsg: 'No more cycles to load....',
        img: 'http://i.imgur.com/qkKy8.gif'
      }
    },
    // call Isotope as a callback
    function( newElements ) {
      $container.isotope( 'appended', $( newElements ) ); 
    }
  );
  $('#filters').on('click', 'a', function(){
    $(this).toggleClass('active');

    //Construct new URl and make calls
  });  
  $(window).scroll(function() {
    if ($(this).scrollTop() != '0'){
      $('#filters a, #filters p').not('.active').addClass('hide');
      $('body').addClass('hide-filters');
    }else{
      $('#filters a, #filters p').removeClass('hide');
      $('body').removeClass('hide-filters');
    }
  });
});