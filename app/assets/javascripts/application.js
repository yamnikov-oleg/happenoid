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

add_tag = function (select) {
	select = $(select);
	value = select.val();
	text = select.find('option:selected').text();
	
	container = $(".tags_field .tags").first();

	if (container.find("#"+value).size() == 0) {
		container.append('<span class="tag" id="'+value+'"><input type="checkbox" name="story[tag['+value+']]" id="story_tag_'+value+'" value="1" onclick="$(".tag#'+value+'").remove();" checked="checked">'+text+'</span>');
	}
}

$(function () {

	page = 1;
	container = $('#container');
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