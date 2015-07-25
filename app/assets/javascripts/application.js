// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

like = function (id) {
	url = '/stories/'+id+'/like'
	$.post(url, function(data, status) {
		if (status == "success") {
			$('#story'+id+' .rating').html(data['rating']);
		}
	});
}

$(function () {

	page = 1;
	container = $('body');
	load_more = $('#load_more');
	url = '/stories';
	options = {offset: '150%'};
	waypoints = null;

	handler = function(direction) {
		waypoints[0].destroy();
		$.get(url, {ajax: 1, page: page}, function (data, status) {
			if(status == "success") {
				load_more.remove();
				container.append(data);
				page++;
			}
			load_more = $('#load_more');
			waypoints = load_more.waypoint(handler, options);
		});
	};

	waypoints = load_more.waypoint(handler, options);

});