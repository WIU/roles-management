// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

base_uri = "";

$(function() {
  $("#group_people_tokens").tokenInput(base_uri + "/people.json", {
    crossDomain: false,
    prePopulate: $("#group_people_tokens").data("pre"),
    theme: "facebook"
  });

  $("#role_people_tokens").tokenInput(base_uri + "/people.json", {
    crossDomain: false,
    prePopulate: $("#role_people_tokens").data("pre"),
    theme: "facebook"
  });

  $("#application_ou_tokens").tokenInput(base_uri + "/ous.json", {
    crossDomain: false,
    prePopulate: $("#application_ou_tokens").data("pre"),
    theme: "facebook"
  });
});
