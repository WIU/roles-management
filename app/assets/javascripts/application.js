//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_self
//= require_tree ./common

// Template-wide Javascript (setting up tabs, buttons, common callbacks, etc.)
(function (template, $, undefined) {
  // 'scope' allows setup of a sidebar within a portion of the DOM. Optional.
  template.setup_sidebar = function (scope) {
    scope = typeof(scope) != 'undefined' ? scope : $(document);
    
    // Hide all sidebar content
    scope.find(".sidebar_content").hide();
    
    // Open a specific tab based on anchors in the URL.
  	if(window.location.hash && window.location.hash.match('sb')) {
  		scope.find("ul.sidemenu li a[href="+window.location.hash+"]").parent().addClass("active").show();
  		scope.find(".block .sidebar_content#"+window.location.hash).show();
  	} else {
  		scope.find("ul.sidemenu li:first-child").addClass("active").show();
  		scope.find(".block .sidebar_content:first").show();
  	}

  	scope.find("ul.sidemenu li").click(function() {
  		var activeTab = $(this).find("a").attr("href");
  		window.location.hash = activeTab;
	
  		$(this).parent().find('li').removeClass("active");
  		$(this).addClass("active");
  		$(this).parents('.block').find(".sidebar_content").hide();			
  		$(activeTab).show();
      
  		return false;
  	});
  }
  
  template.status_text = function(message) {
    $("div.status_bar").show().html(message);
  }
  
  template.hide_status = function() {
    $("div.status_bar").hide();
  }
  
  template.setup_default_text = function(scope) {
    scope = typeof(scope) != 'undefined' ? scope : $(document);
    
    scope.on("focus", "input[data-default-text]", function(srcc) {
      if($(this).attr("readonly") != "readonly") {
        if($(this).val() == $($(this)[0]).attr("data-default-text")) {
          $(this).removeClass("default_text_active");
          $(this).val("");
        }
      }
    });
    scope.on("blur", "input[data-default-text]", function() {
      if ($(this).val() == "") {
        $(this).addClass("default_text_active");
        $(this).val($($(this)[0]).attr("data-default-text"));
      }
    });
    scope.find("input[data-default-text]").each(function() {
    	$(this).blur();
    });
  }
} (window.template = window.template || {}, jQuery));

// For dynamic, nested attribute add/remove
function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).parent().prev().children("tbody").append(content.replace(regexp, new_id));
  //$(link).parent().before(content.replace(regexp, new_id));
}

$(function() {
  // Set up the token inputs
  $("#role_people_tokens").tokenInput($("#role_people_tokens").attr("method") + ".json", {
    crossDomain: false,
    prePopulate: $("#role_people_tokens").data("pre"),
    theme: "facebook"
  });

  $("#role_group_tokens").tokenInput($("#role_group_tokens").attr("method") + ".json", {
    crossDomain: false,
    prePopulate: $("#role_group_tokens").data("pre"),
    theme: "facebook"
  });

  $("#application_ou_tokens").tokenInput($("#application_ou_tokens").attr("method") + ".json", {
    crossDomain: false,
    prePopulate: $("#application_ou_tokens").data("pre"),
    theme: "facebook"
  });
  
  $("#ou_parent_tokens").tokenInput($("#ou_parent_tokens").attr("method") + ".json", {
    crossDomain: false,
    prePopulate: $("#ou_parent_tokens").data("pre"),
    theme: "facebook"
  });

  $("#ou_manager_tokens").tokenInput($("#ou_manager_tokens").attr("method") + ".json", {
    crossDomain: false,
    prePopulate: $("#ou_manager_tokens").data("pre"),
    theme: "facebook"
  });

  $("#classification_title_tokens").tokenInput($("#classification_title_tokens").attr("method") + ".json", {
    crossDomain: false,
    prePopulate: $("#classification_title_tokens").data("pre"),
    theme: "facebook"
  });
  
  // /people/new/:loginid specific
  $("input[name=fetch_ldap_details]").click(function() {
    var loginid = $("input[name=fetch_ldap_details_field]").val();
    document.location.href = document.location.href + "/" + loginid;
  });

  // Preload images
	$.preloadCssImages();
	
	// CSS tweaks
	$('#header #nav li:last').addClass('nobg');
	$('.block_head ul').each(function() { $('li:first', this).addClass('nobg'); });
	$('.block form input[type=file]').addClass('file');
	
	// Web stats
	$('table.stats').each(function() {
		
		if($(this).attr('rel')) {
			var statsType = $(this).attr('rel');
		} else {
			var statsType = 'area';
		}
		
		var chart_width = ($(this).parent('.block_content').width()) - 60;
		
		if(statsType == 'line' || statsType == 'pie') {		
			$(this).hide().visualize({
				type: statsType,	// 'bar', 'area', 'pie', 'line'
				width: chart_width,
				height: '240px',
				colors: ['#6fb9e8', '#ec8526', '#9dc453', '#ddd74c'],
				
				lineDots: 'double',
				interaction: true,
				multiHover: 5,
				tooltip: true,
				tooltiphtml: function(data) {
					var html ='';
					for(var i=0; i<data.point.length; i++){
						html += '<p class="chart_tooltip"><strong>'+data.point[i].value+'</strong> '+data.point[i].yLabels[0]+'</p>';
					}	
					return html;
				}
			});
		} else {
			$(this).hide().visualize({
				type: statsType,	// 'bar', 'area', 'pie', 'line'
				width: chart_width,
				height: '240px',
				colors: ['#6fb9e8', '#ec8526', '#9dc453', '#ddd74c']
			});
		}
	});
	
	// Sort table
	$("table.sortable").tablesorter({
		headers: { 0: { sorter: false}, 5: {sorter: false} },		// Disabled on the 1st and 6th columns
		widgets: ['zebra']
	});
	
	$('.block table tr th.header').css('cursor', 'pointer');
	
	// Check / uncheck all checkboxes
	$('.check_all').click(function() {
		$(this).parents('form').find('input:checkbox').attr('checked', $(this).is(':checked'));   
	});
	
	// Set WYSIWYG editor
	//$('.wysiwyg').wysiwyg({css: "<%= asset_path "wysiwyg/wysiwyg.css" %>" });
	
	// Modal boxes - to all links with rel="facebox"
	//$('a[rel*=facebox]').facebox()
	
	// Messages
	$('.block .message').hide().append('<span class="close" title="Dismiss"></span>').fadeIn('slow');
	$('.block .message .close').hover(
		function() { $(this).addClass('hover'); },
		function() { $(this).removeClass('hover'); }
	);
		
	$('.block .message .close').click(function() {
		$(this).parent().fadeOut('slow', function() { $(this).remove(); });
	});
	
	// Tabs
	$(".tab_content").hide();
	
	// Set .active if URL anchor matches any tab
	if(window.location.hash) {
	  // Anchor-based navigation
	  $("ul.tabs li").find("a").each(function(index, value) {
	    p = value.toString().indexOf("#");
	    
	    if(value.toString().substr(p) == window.location.hash) {
	      // found it, add .active
	      $($("ul.tabs li")[index]).addClass("active");
	      return; // stop
	    }
	  });
	}
	
  // Activate the first tab if 'active' is not set already
  if($("ul.tabs").find(".active").length == 0) {
    $("ul.tabs li:first-child").addClass("active").show(); // activate the first tab
  }

  // Activate whatever tab is active, not necessarily going to be the first
  $($(".block").find(".tabs li.active").find("a").attr("href")).show();

	$("ul.tabs li").click(function() {
	  // Only switch tabs if the link is to an anchor
	  if($(this).find("a").attr("href")[0] == "#") {
  		$(this).parent().find('li').removeClass("active");
  		$(this).addClass("active");
  		$(this).parents('.block').find(".tab_content").hide();
			
  		var activeTab = $(this).find("a").attr("href");
  		$(activeTab).show();
		
  		// refresh visualize for IE
  		$(activeTab).find('.visualize').trigger('visualizeRefresh');
		
  		return false;
	  }
	});
	
	template.setup_sidebar();
  template.setup_default_text();
	
	// Block search
	$('.block .block_head form .text').bind('click', function() { $(this).attr('value', ''); });
	
	// Image actions menu
	$('ul.imglist li').hover(
		function() { $(this).find('ul').css('display', 'none').fadeIn('fast').css('display', 'block'); },
		function() { $(this).find('ul').fadeOut(100); }
	);
		
	// Image delete confirmation
	$('ul.imglist .delete a').click(function() {
		if (confirm("Are you sure you want to delete this image?")) {
			return true;
		} else {
			return false;
		}
	});
	
	// Style file input
	//$("input[type=file]").filestyle({ 
	//    image: "images/upload.gif",
	//    imageheight : 30,
	//    imagewidth : 80,
	//    width : 250
	//});
	
	// File upload
	if ($('#fileupload').length) {
		new AjaxUpload('fileupload', {
			action: 'upload-handler.php',
			autoSubmit: true,
			name: 'userfile',
			responseType: 'text/html',
			onSubmit : function(file , ext) {
					$('.fileupload #uploadmsg').addClass('loading').text('Uploading...');
					this.disable();	
				},
			onComplete : function(file, response) {
					$('.fileupload #uploadmsg').removeClass('loading').text(response);
					this.enable();
				}	
		});
	}
	
	// Date picker
	$('input.date_picker').datepicker();

	// Navigation dropdown fix for IE6
	//if(jQuery.browser.version.substr(0,1) < 7) {
	//	$('#header #nav li').hover(
	//		function() { $(this).addClass('iehover'); },
	//		function() { $(this).removeClass('iehover'); }
	//	);
	//}
	
	// IE6 PNG fix
	//$(document).pngFix();

  // Fix AJAX headers
  $.ajaxSetup({
    beforeSend: function (xhr, settings) {
      xhr.setRequestHeader("accept", '*/*;q=0.5, ' + settings.accepts.script);
    }
  });
  
  // Set up tool tips
  $("[data-tooltip]").each(
    function() {
      $(this).qtip({
        content: $(this).attr("data-tooltip"),
        show: 'mouseover',
        hide: 'mouseout',
        position: {
          corner: {
            target: 'bottomMiddle',
            tooltip: 'topMiddle'
          }
        }
      });
    }
  );
  
  
});