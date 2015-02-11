# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

###
YOUTUBE API AND PLAYER FUNCTIONS
###
tag = document.createElement('script')
tag.src = "https://www.youtube.com/player_api"
scriptArray = document.getElementsByTagName('script')
firstScriptTag = scriptArray[scriptArray.length - 1]
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)

window = exports ? this

window.players = [];

isPlaying = false;

@onPlayerStateChange = (event, id, player, start) -> # Seeks to start and pauses if not on screen

  if event.data == 1 and not player.onFirstSeekDone # Checks if event is valid and onFirstSeek hasn't been marked done

    onFirstSeek = () -> # Pause player and mark done

      player.onFirstSeekDone = true # Mark done

    if not $('#bit-box_' + id).isOnScreen(1, 0.8)  # Checks if player is not on screen
      player.pauseVideo();

    onFirstSeek()

getCookie = (key) ->
  cookieArray = document.cookie.split(';');

  for cookie in cookieArray when $.trim(cookie.split('=')[0]) is key
    return cookie.split('=')[1]

  return "";


@onPlayerReady = (id, player, start, end) ->

  # Seek player to start and get controls functioning

  player.seekTo(start);

  displayMuted = () ->
    $('.mute-bit-button').each ->
      $(this).html('<i class="fa fa-volume-off fa-2x"></i><i class="fa fa-close mute-bit-icon"></i>')


  displayUnMuted = () ->
    $('.mute-bit-button').each ->
      $(this).html('<i class="fa fa-volume-up fa-2x"></i>')

  if getCookie("muted") is 'true' # checks if player is muted and then either toggles the volume button off or on
    displayMuted()
    player.mute()

  else
    displayUnMuted()
    player.unMute()

  $('#video--mute-box_'+id).hover ->  # when mouse is over video and mute button
    $('#mute-bit-button_'+id).animate( # show the mute button
      opacity: '0.6'
    , 100)
  , ->
    $('#mute-bit-button_'+id).animate( # otherwise hide the mute button
      opacity: '0'
    , 100)

  $('#mute-bit-button_'+id).click ->  # Mute/unmute on click

    if player.isMuted()
      console.log("unmute");
      displayUnMuted()

      for own key, value of window.players
        window.players[key].unMute();

      document.cookie = "muted=false"

    else
      console.log("mute");
      displayMuted()

      for own key, value of window.players
        window.players[key].mute();

      document.cookie = "muted=true"

  player.oldVideoTime = start

  updateTime = () -> # If video time has actually changed, run onProgress()
    newVideoTime = player.getCurrentTime()
    if newVideoTime isnt player.oldVideoTime
      onProgress(newVideoTime, player, start, end)
      player.oldVideoTime = newVideoTime

  setInterval(updateTime, 100)
  playOnView(id,player)


onProgress = (currentTime, player, start, end) -> # If the video time is greater than the end time, seek video to the start time
  if currentTime > end
    player.seekTo(start);
    player.playVideo();


$ ->
  $('.bit-button').hover( ->
  # Underline animation for buttons under player
    console.log("hover")
    $(this).children("span").toggleClass("underline")
    return
)

playOnView = (id, player) -> # Play on screen view handlers

  $(window).on 'DOMContentLoaded load resize scroll', ->
    onVisibilityChange();
  # On screen movement run onVisibilityChange

  onVisibilityChange = () -> # Play video if it is in the view; otherwise pause the video (as long as it already completed the initial seek)

    if $('#bit-box_' + id).isOnScreen(1, 0.8) and not window.isPlaying
      player.playVideo()
      window.isPlaying = true

    else if (player.onFirstSeekDone)
      player.pauseVideo()
      window.isPlaying = false
###
 IS ON SCREEN FUNCTION
###
`(function ($) {

$.fn.isOnScreen = function(x, y){

  if(x == null || typeof x == 'undefined') x = 1;
if(y == null || typeof y == 'undefined') y = 1;

var win = $(window);

var viewport = {
  top : win.scrollTop(),
  left : win.scrollLeft()
};
viewport.right = viewport.left + win.width();
viewport.bottom = viewport.top + win.height();

var height = this.outerHeight();
var width = this.outerWidth();

if(!width || !height){
  return false;
}

var bounds = this.offset();
bounds.right = bounds.left + width;
bounds.bottom = bounds.top + height;

var visible = (!(viewport.right < bounds.left || viewport.left > bounds.right || viewport.bottom < bounds.top || viewport.top > bounds.bottom));

if(!visible){
  return false;
}

var deltas = {
  top : Math.min( 1, ( bounds.bottom - viewport.top ) / height),
  bottom : Math.min(1, ( viewport.bottom - bounds.top ) / height),
  left : Math.min(1, ( bounds.right - viewport.left ) / width),
  right : Math.min(1, ( viewport.right - bounds.left ) / width)
};

return (deltas.left * deltas.right) >= x && (deltas.top * deltas.bottom) >= y;

};

})(jQuery);`
