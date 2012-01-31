(function (details_modal, $, undefined) {
  details_modal.EDIT_MODE = 0;
  details_modal.VIEW_MODE = 1;
  
  details_modal.switch_mode = function(mode) {
    switch(mode) {
      case details_modal.EDIT_MODE:
      // Turn on inputs
      $("div#details_view .sidebar_content input,textarea")
        .css("border", "1px solid #bbb")
        .attr("readonly", false);
      // Turn on token inputs
      $(".token_input").each(function() {
        $(this).tokenInput("toggleDisabled", {disable: false});
      });
      // Turn on dropdowns
      $("select")
        .removeClass("disabled")
        .attr("disabled", false);
      // Turn on any anchor-based controls
      $("a.edit_mode").show();
      // Show unchecked boxes
      $("input[type=checkbox]:not(:checked)").show();
      break;
      case details_modal.VIEW_MODE:
      // Turn off inputs
      $("div#details_view .sidebar_content input,textarea")
        .css("border", "1px solid #fff")
        .attr("readonly", true);
      // Turn off token inputs
      $(".token_input").each(function() {
        $(this).tokenInput("toggleDisabled", {disable: true});
      });
      // Turn off dropdowns
      $("select")
        .addClass("disabled")
        .attr("disabled", true);
      // Turn off any anchor-based controls
      $("a.edit_mode").hide();
      // Hide unchecked boxes
      $("input[type=checkbox]:not(:checked)").hide();
      break;
      default: break;
    }
  }
    
} (window.details_modal = window.details_modal || {}, jQuery));

$(document).ready(function() {
  if($("#person_ou_tokens").length > 0) {
    // Person details modal
    $("#person_ou_tokens").tokenInput($("#person_ou_tokens").attr("method") + ".json", {
      crossDomain: false,
      defaultText: "No organizations",
      prePopulate: $("#person_ou_tokens").data("pre"),
      theme: "facebook"
    });

    $("#person_group_tokens").tokenInput($("#person_group_tokens").attr("method") + ".json", {
      crossDomain: false,
      defaultText: "No groups",
      prePopulate: $("#person_group_tokens").data("pre"),
      theme: "facebook"
    });

    $("#person_subordinate_tokens").tokenInput($("#person_subordinate_tokens").attr("method") + ".json", {
      crossDomain: false,
      defaultText: "No subordinates",
      prePopulate: $("#person_subordinate_tokens").data("pre"),
      theme: "facebook"
    });
  }
  
  if($("#group_member_tokens").length > 0) {
    // Group details modal
    $("#group_member_tokens").tokenInput($("#group_member_tokens").attr("method") + ".json", {
      crossDomain: false,
      prePopulate: $("#group_member_tokens").data("pre"),
      theme: "facebook",
      defaultText: "No members",
      onAdd: function (item) {
        console.log("Added " + item);
      },
      onDelete: function (item) {
        console.log("Deleted " + item);
      }
    });

    $("#group_owner_tokens").tokenInput($("#group_owner_tokens").attr("method") + ".json", {
      crossDomain: false,
      defaultText: "No owners",
      prePopulate: $("#group_owner_tokens").data("pre"),
      theme: "facebook"
    });
  }
  
  if($("#application_ou_tokens").length > 0) {
    // Application details modal
    $("#application_ou_tokens").tokenInput($("#application_ou_tokens").attr("method") + ".json", {
      crossDomain: false,
      defaultText: "Everybody",
      prePopulate: $("#application_ou_tokens").data("pre"),
      theme: "facebook"
    });
  }
  
  $("button#edit").click(function() {
    // Button toggles edit mode
    if($(this).html() == "Edit") {
      // turning editing on
      $(this).html("Done").css("color", "#db6c67");
      details_modal.switch_mode(details_modal.EDIT_MODE);
    } else {
      // turning editing off
      $(this).html("Edit").css("color", "#000");
      details_modal.switch_mode(details_modal.VIEW_MODE);
    }
  }).hover(
    // fix jQuery's CSS hover mistake. TODO: fix this using css / apprise patching instead?
    function() {
      $(this).css("color", "#db6c67");
    },
    function() {
      if($(this).html() == "Edit") {
        $(this).css("color", "#000");
      } else {
        $(this).css("color", "#1eaaeb");
      }
    }
  );
  
  details_modal.switch_mode(details_modal.VIEW_MODE);
});