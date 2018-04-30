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

        loadImage.parseMetaData(f, function(data) {
            var orientation = 0;
            if (data.exif) {
                orientation = data.exif.get('Orientation');
            }
            var loadingImage = loadImage(
                f,
                function(canvas) {
                    //here's the base64 data result
                    var base64data = canvas.toDataURL('image/jpeg');
                    var img_src = base64data.replace(/^data\:image\/\w+\;base64\,/, '');
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        var html = "<div class='img_holder'><img class='uploaded_img' src=\"" + base64data + "\"/></div>";
                        selDiv.innerHTML += html;
                    }
                    reader.readAsDataURL(f);
                }, {
                    canvas: true,
                    orientation: orientation
                }
            );
        });
    });
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
    document.getElementsByClassName('zmdi-facebook')[0].classList.toggle('fb_clicked');
}

function toggleTwitter() {
    document.getElementsByClassName('zmdi-twitter')[0].classList.toggle('tw_clicked');
}

function toggleMastodon() {
    document.getElementsByClassName('zmdi-face')[0].classList.toggle('ma_clicked');
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
            url: '/application/req_unfavorite',
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
            url: '/application/req_favorite',
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
            url: '/application/req_unrepost',
            data: {provider: provider, id: id},
            type: 'post'
        });
    } else {
        favorite.classList.add('reposted');
        favorite.classList.remove('not_reposted');
        repostCount.innerHTML = parseInt(repostCount.innerHTML) + 1;
        $.ajax({
            url: '/application/req_repost',
            data: {provider: provider, id: id},
            type: 'post'
        });
    }
}

function toggleArchived(prov_id) {
    var provider = prov_id.split('_')[0]
    var id = prov_id.split('_')[1]
    var archive = document.getElementById(provider + '_arch_' + id);
    if (archive.classList.contains('archived')) {
        archive.classList.remove('archived');
        archive.classList.remove('zmdi-star');
        archive.classList.add('not_archived');
        archive.classList.add('zmdi-star-outline');
        $.ajax({
            url: '/application/req_unarchive_post',
            data: {provider: provider, id: id},
            type: 'post'
        });
    } else {
        archive.classList.add('archived');
        archive.classList.add('zmdi-star');
        archive.classList.remove('zmdi-star-outline');
        archive.classList.remove('not_archived');
        $.ajax({
            url: '/application/req_archive_post',
            data: {provider: provider, id: id},
            type: 'post'
        });
    }
}

function toggleProviderFilter(provider) {
    if (provider == 'Twitter') {
        var twitter = document.getElementsByClassName('zmdi-twitter')[0];
        var twitter_posts = document.getElementsByClassName('twitter_post')
        if (twitter.classList.contains('tw_clicked')) {
            twitter.classList.remove('tw_clicked');
            for (var i = 0; i < twitter_posts.length; ++i) {
                twitter_posts[i].classList.add('hidden');
            }
        } else {
            twitter.classList.add('tw_clicked');
            for (var i = 0; i < twitter_posts.length; ++i) {
                twitter_posts[i].classList.remove('hidden');
            }
        }
    } else if (provider == 'Mastodon') {
        var mastodon = document.getElementsByClassName('zmdi-face')[0];
        var mastodon_posts = document.getElementsByClassName('mastodon_post')
        if (mastodon.classList.contains('ma_clicked')) {
            mastodon.classList.remove('ma_clicked');
            for (var i = 0; i < mastodon_posts.length; ++i) {
                mastodon_posts[i].classList.add('hidden');
            }
        } else {
            mastodon.classList.add('ma_clicked');
            for (var i = 0; i < mastodon_posts.length; ++i) {
                mastodon_posts[i].classList.remove('hidden');
            }
        } 
    } 
}

function filterFeedSearch(query) {
    var twitterPosts = document.getElementsByClassName('twitter_post');
    var twitterPostsSize = twitterPosts.length;
    for (var i = 0; i < twitterPostsSize; ++i) {
        var postContent = twitterPosts[i].innerHTML;
        if (postContent.indexOf(query) > -1) {
            twitterPosts[i].classList.remove('filtered_out');
        } else {
            twitterPosts[i].classList.add('filtered_out');
        }
    }

    var mastodonPosts = document.getElementsByClassName('mastodon_post');
    var mastodonPostsSize = mastodonPosts.length;
    for (var i = 0; i < mastodonPostsSize; ++i) {
        var postContent = mastodonPosts[i].innerHTML;
        if (postContent.indexOf(query) > -1) {
            mastodonPosts[i].classList.remove('filtered_out');
        } else {
            mastodonPosts[i].classList.add('filtered_out');
        }
    }
}