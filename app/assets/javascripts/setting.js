// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
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

function flip(provider) {
    if(provider == 'twitter') {
        $('.card-twitter').toggleClass('flipped');
    } else if(provider == 'facebook') {
        $('.card-facebook').toggleClass('flipped');
    } else if(provider == 'mastodon') {
        $('.card-mastodon').toggleClass('flipped');
    }
}

function drawMetricChart(elementId, chartTitle, twitter, facebook, mastodon) {
    google.charts.load('current', {'packages':['corechart']});
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
        var data;
        dataArray = [['Provider', 'Count']];
        color_data = [];
        if (twitter != -1) {
            dataArray.push(['Twitter', parseInt(twitter)]);
            color_data.push('#00aced');
        }
        
        if (facebook != -1) {
            dataArray.push(['Facebook', parseInt(facebook)]);
            color_data.push('#3B5998');
        }
        
        if (mastodon != -1) {
            dataArray.push(['Mastodon', parseInt(mastodon)]);
            color_data.push('#444B5D');
        }
        
        if ((twitter == 0 || twitter == -1) && (facebook == 0 || facebook == -1) && (mastodon == 0 || mastodon == -1)) {
            var data = google.visualization.arrayToDataTable([
                ['Provider', 'Count'],
                ['More Data Needed', 1]
            ]);
            color_data = ['black'];
        } else {
            var data = google.visualization.arrayToDataTable(dataArray);
        }
    
        var options = { title: chartTitle,
            backgroundColor: 'transparent',
            colors: color_data,
            sliceVisibilityThreshold: 0,
            chartArea:{width:'70%',height:'75%'},
            titleTextStyle: {fontSize: 22}
        };
  
        var chart = new google.visualization.PieChart(document.getElementById(elementId));
        chart.draw(data, options);
    }
}