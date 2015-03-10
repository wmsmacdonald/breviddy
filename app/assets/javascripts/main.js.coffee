
preload = () ->
  if document.images
    img1 = new Image()
    img1.src = image_path('logo-dark.png')
    return


preload();

$ ->
  $('#logo-box img').hover ->
    $('#logo').attr('src', image_path('logo-dark.png'))
    return
  , ->
    $('#logo').attr('src', image_path('logo.png'))
    return
  ;
  $('.banner-button').hover ->
    $(this).addClass('banner-button-selected')
  , ->
    $(this).removeClass('banner-button-selected')


`
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
ga('create', 'UA-50244607-2', 'auto');
ga('send', 'pageview');
`