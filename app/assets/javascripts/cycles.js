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
  
(function() {
  var loading = false;
  uri_query = ptq(location.href);
  if(uri_query["search[min_price]"] && uri_query["search[max_price]"]) {
      $(".noUiSlider").val([uri_query['search[min_price]'][0],uri_query['search[max_price]'][0]]) 
  }
  });
  $('.search-tag').change(function(){
    getProducts();
     });

  $(".noUiSlider").noUiSlider({
    range: [0, 150000]
    ,start: [0, 150000]
    ,handles: 2
    ,step: 1000
    ,slide: function(){
      var values = $(this).val();
      $("span.range").text(
        values[0] + " - " + values[1]
      );
        getProducts();
    }
  });

  function getQuery(){
    var brands_query = "";
    var ages_query = "";
    var types_query = "";
    var max_price,min_price;

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
    
    price_value = $(".noUiSlider").val()
    max_price = "&search[max_price]="+price_value[1];
    min_price = "&search[min_price]="+price_value[0];
    

    query = brands_query + ages_query + types_query+ max_price+ min_price;

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
     if(uri_query["search[min_price]"] && uri_query["search[max_price]"]) {
      $(".noUiSlider").val([uri_query['search[min_price]'][0],uri_query['search[max_price]'][0]]) 
    }
    });
  })
  
  function getProducts(){
  query = getQuery();
    $.ajax({
      url: '/cycles?page=1'+query ,
      type: 'get',
      dataType: 'script',
      success: function(){
        history.pushState(null, "", "?page=1"+query);
      }
    });
  }

}());

