//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require rails_emoji_picker
//= require_tree .

var selDiv = "";
    
document.addEventListener("DOMContentLoaded", init, false);

function init() {
    document.querySelector('#images').addEventListener('change', handleFileSelect, false);
    selDiv = document.querySelector("#img_container");
}
    
function handleFileSelect(e) {
    if(!e.target.files || !window.FileReader) return;

    selDiv.innerHTML = "";
    
    var files = e.target.files;
    var filesArr = Array.prototype.slice.call(files);
    filesArr.forEach(function(f) {
        if(!f.type.match("image.*")) {
            return;
        }

        var reader = new FileReader();
        reader.onload = function (e) {
            var html = "<img class='uploaded_img' src=\"" + e.target.result + "\">";
            selDiv.innerHTML += html;
        }
        reader.readAsDataURL(f);
    });
    
}

function showEdit() {
    var edit_buttons = document.getElementsByClassName('provider_edit');
    for (var i = 0; i < edit_buttons.length; ++i) {
        var currentEdit = edit_buttons[i];
        if (currentEdit.classList.contains('hidden')) {
            currentEdit.classList.remove('hidden');
        } else {
            currentEdit.classList.add('hidden');
        }
    }
}

window.onload = function() {
    var url = window.location.href;
    if (url.includes('feeds/index') || url.includes('#_=_')) {
        document.getElementById('feed').classList.add('is-active');
    } else if (url.includes('feeds/messages')) {
        document.getElementById('messages').classList.add('is-active');
    } else if (url.includes('feeds/post')) {
        document.getElementById('post').classList.add('is-active');
    } else if (url.includes('feeds/archives')) {
        document.getElementById('archives').classList.add('is-active');
    } else if (url.includes('feeds/notifications')) {
        document.getElementById('notifications').classList.add('is-active');
    }
}

function toggleFacebook() {
    var facebook = document.getElementsByClassName('zmdi-facebook')[0];
    if (facebook.classList.contains('fb_clicked')) {
        facebook.classList.remove('fb_clicked');
    } else {
        facebook.classList.add('fb_clicked');
    }
}

function toggleTwitter() {
    var twitter = document.getElementsByClassName('zmdi-twitter')[0];
    if (twitter.classList.contains('tw_clicked')) {
        twitter.classList.remove('tw_clicked');
    } else {
        twitter.classList.add('tw_clicked');
    }
}

function toggleFavorite(prov_id) {
    var provider = prov_id.split('_')[0]
    var id = prov_id.split('_')[1]
    var favorite = document.getElementById(provider + '_fav_' + id);
    var favoriteCount = document.getElementById(provider + '_favcount_' + id)
    if (favorite.classList.contains('favorited')) {
        favorite.classList.remove('favorited');
        favorite.classList.remove('zmdi-favorite');
        favorite.classList.add('not_favorited');
        favorite.classList.add('zmdi-favorite-outline');
        favoriteCount.innerHTML = parseInt(favoriteCount.innerHTML) - 1;
        $.ajax({
            url: '/application/unfavorite',
            data: {provider: provider, id: id},
            type: 'post'
        });
    } else {
        favorite.classList.add('favorited');
        favorite.classList.add('zmdi-favorite');
        favorite.classList.remove('zmdi-favorite-outline');
        favorite.classList.remove('not_favorited');
        favoriteCount.innerHTML = parseInt(favoriteCount.innerHTML) + 1;
        $.ajax({
            url: '/application/favorite',
            data: {provider: provider, id: id},
            type: 'post'
        });
    }
}

function toggleRepost(prov_id) {
    var provider = prov_id.split('_')[0]
    var id = prov_id.split('_')[1]
    var token = prov_id.split('_')[2]
    var favorite = document.getElementById(provider + '_rep_' + id);
    var repostCount = document.getElementById(provider + '_repcount_' + id)
    if (favorite.classList.contains('reposted')) {
        favorite.classList.remove('reposted');
        favorite.classList.add('not_reposted');
        repostCount.innerHTML = parseInt(repostCount.innerHTML) - 1;
        $.ajax({
            url: '/application/unrepost',
            data: {provider: provider, id: id},
            type: 'post'
        });
    } else {
        favorite.classList.add('reposted');
        favorite.classList.remove('not_reposted');
        repostCount.innerHTML = parseInt(repostCount.innerHTML) + 1;
        $.ajax({
            url: '/application/repost',
            data: {provider: provider, id: id},
            type: 'post'
        });
    }
}