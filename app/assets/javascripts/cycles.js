(function() {
  var loading = false;

  function nearBottomOfPage() {
    return $(window).scrollTop() > $(document).height() - $(window).height() - 300;
  }

  function endOfResults() {
    return $('#infinite-scroll').length ? true : false;
  }

  $(window).scroll(function(){
    if (loading) {
      return;
    }

    if(nearBottomOfPage() && endOfResults()) {
      loading=true;
      page = parseInt($('#infinite-scroll').attr('data-next-page'));
      query = getQuery();
      $.ajax({
        url: '/cycles?infinite=true&page=' + page + query,
        type: 'get',
        dataType: 'script',
        success: function() {
          loading = false;
        }
      });
    }
  });

  $(window).sausage();


  $('.search-tag').change(function(){

    query = getQuery();
    $.ajax({
      url: '/cycles?page=1'+query ,
      type: 'get',
      dataType: 'script',
      success: function(){
        history.pushState(null, "", "?page=1"+query);
      }
    });

  });

  $(".noUiSlider").noUiSlider({
    range: [0, 150000]
    ,start: [0, 150000]
    ,step: 1000
    ,slide: function(){
      var values = $(this).val();
      $("span.range").text(
        values[0] +
        " - " +
        values[1]
      );
    }
  });

  function getQuery(){
    var brands_query = ""
    var ages_query = ""
    var types_query = ""

    $.each($('.brands:checked'),function(index,element){
      search_query =   "&search[brand][]="+element.value;
      brands_query+= search_query;
    });

    $.each($('.ages:checked'),function(index,element){
      search_query =   "&search[age][]="+element.value;
      ages_query+= search_query;
    });

    $.each($('.types:checked'),function(index,element){
      search_query =   "&search[type][]="+element.value;
      types_query+= search_query; 
    });

    query = brands_query + ages_query + types_query;

    return query
  }

  $(function () {
    // Other functions omitted.
    $(window).bind("popstate", function () {
      $.getScript(location.href);
      $('input:checkbox').removeAttr('checked');
      uri_query = ptq(location.href);
      queries = ["type","brand","age"];
      queries.forEach(function(query){
        if(uri_query['search['+query+'][]']){
          uri_query['search['+query+'][]'].forEach(function(item){
            $('#'+item).attr('checked','checked'); 
          });
        }
      }); 
    });
  })
}());
