jQuery ->
  if $('#infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      more_bits_url = $('.pagination .next_page a').attr('href')
      if more_bits_url && $(window).scrollTop() > $(document).height() - $(window).height() - 400 # last num: bigger -> paginate further up
        $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
        $.getScript more_bits_url

      return
    return
