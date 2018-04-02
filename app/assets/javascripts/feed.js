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

            var reader = new FileReader();
            reader.onload = function (e) {
                var html = "<img class='uploaded_img' src=\"" + e.target.result + "\">";
                selDiv.innerHTML += html;
            }
            reader.readAsDataURL(f);
        });
        
    }