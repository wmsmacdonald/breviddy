$(document).ready(function() {
    $('#url-input').off(); // makes sure events are cleared on the input first (o.w. will run urlEnter twice)
    $('#url-input').on("paste", urlEnter);
    $('#url-input').on("enterKey", urlEnter);
    $('#url-input').keyup(function(e) { // bind enter key press to url enter function
        if (e.keyCode == 13) {
            $(this).trigger("enterKey");
        }
    });
    resetHTML();
});

function urlEnter() {

    console.log("enter");

    resetHTML();

    setTimeout(function () { // slight delay so the input enter works #messyworkarounds

        url = $('#url-input').val();


        function initializePlayer(url) {

            urlId = parseYTUrl(url);
            if (urlId === true) {
                return false;
            }
            console.log("new player");
            var embedSuccess = true;
            window.player = new YT.Player('ytplayer', {
                height: '300',
                width: '450',
                videoId: urlId,
                playerVars: {'iv_load_policy': 3, 'controls': 0, 'rel': 1, 'showinfo': 1},
                events: {
                    'onReady': function () {
                        console.log("player ready");
                        onPlayerReady();
                    },
                    'onError': function (data) {
                        embedSuccess = false;
                    },
                    'onStateChange': function (data) {
                        if (player.getPlayerState() == 1) {
                            // change icon to play
                            $('#toggle-play-button').html('<i class="fa fa-pause fa-2x"></i>');
                        }
                        else {
                            $('#toggle-play-button').html('<i class="fa fa-play fa-2x"></i>');
                        }
                    }
                }
            });

            return embedSuccess;

        }

        var playerSuccess = initializePlayer(url);

        if(playerSuccess) {

            $('#upper-spacer').animate({ // decrease the upper spacer, moving content up, in an animation
                height: "10px"
            }, 300, function () {

            });

        }

    }, 0);
}

function onPlayerReady() {

    trimVideoHTML();

} // end onPlayerReady()

function resetHTML() { // only display the url input

    $('#ytplayer-box').html('<div id="ytplayer"></div>');
    $('#seek-slider-box').html('');
    $('#cut-slider-box').html('');
    $('#form-box').hide();
    $('#trim-instructions').hide();
    $('#controls-box').hide();
    //$('#back-link').show();
    if (typeof window.id !== 'undefined') {
        window.clearInterval(window.id);
    }
}

function trimVideoHTML() { // display the UI for trimming the video
    $('#url-instructions').hide();
    $('#trim-instructions').show();
    $('#form-box').show();
    $('#controls-box').show();
    //$('#back-link').hide();


    window.player.playVideo();
    window.player.unMute();
    window.slidertime = 0;

    $('#seek-slider-box').html('<input id="seek-slider" type="text">');
    $('#cut-slider-box').html('<input id="cut-slider" type="text">');

    $('#seek-slider').ionRangeSlider({
        max: window.duration,
        min: 0,
        hide_min_max: true,
        hide_from_to: true,
        onStart: function(data) {
            window.seeking = false;
        },
        onFinish: function(data) {
            window.player.seekTo(Math.round(window.slidertime));
            setTimeout(function() {
                window.seeking = false;
            }, 100);
        },
        onChange: function(data) {
            window.slidertime = data.from;
            window.seeking = true;
        },
        onUpdate: function(data) {
            window.slidertime = data.from;
        }
    });

    window.slider_to_time = 0;
    window.seek_slider = $("#seek-slider").data("ionRangeSlider");
    $('#cut-slider').ionRangeSlider({
        type: "double",
        min: 0,
        max: window.duration,
        prettify: function (num) {
            minutes = Math.floor(num / 60).toString();
            seconds = (num - minutes * 60).toString();
            if (minutes.length == 1) {
                minutes = "0" + minutes;
            }
            if (seconds.length == 1) {
                seconds = "0" + seconds;
            }
            return minutes+":"+seconds;
        },
        hide_min_max: true,
        min_interval: 2,
        onFinish: function(data) {
            $('#bit_start').val(Math.round(data.from));
            $('#bit_end').val(Math.round(data.to));
            if (data.from !== window.slider_to_time) {
                window.player.seekTo(Math.round(data.from));
                window.player.playVideo();
                window.slider_to_time = data.from;
            }
        }
    });
    $('.triangle').css({"border": "none"});
    window.id = window.setInterval(moveSlider, 50);
    function moveSlider() {
        videotime = Math.round(window.player.getCurrentTime());
        slidertime = Math.round(window.slidertime);
        endtime = Math.round($('#bit_end').val());

        if (videotime >= endtime || window.player.getPlayerState() == 0) {
            window.player.seekTo($('#bit_start').val());
            //console.log("moving");
        }
        if (videotime != slidertime & !window.seeking) {
            window.seek_slider.update({
                from: videotime
            });
        }
    }
    $('#bit_url').val($('#url-input').val());
    $('#bit_start').val(0);
    $('#bit_end').val(window.player.getDuration());
    //$('#bit_title').val(window.title);

    $('#toggle-play-button').click(function() {
        if (player.getPlayerState() == 1) {
            window.player.pauseVideo();
        }
        else {
            window.player.playVideo();
        }

    });
    $('#toggle-mute-button').click(function() {
        if (player.isMuted()) {
            window.player.unMute();
            $(this).html('<i class="fa fa-volume-up fa-2x"></i>');
        }
        else {
            window.player.mute();
            $(this).html('<i class="fa fa-volume-off fa-2x"></i><i class="fa fa-close"></i>');

        }

    });
}

function parseYTUrl(url) { // return the video id from the url; return false on failure

    regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
    match = url.match(regExp);
    if (match && match[2].length == 11) {
        return match[2];
    }
    else {
        return false;
    }
}

function onError(msg) {
    resetHTML();
    $('#url-instructions').show();
    $('#super-box').before('<p class="alert alert-danger"><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>'+msg+'</span></p>');
}