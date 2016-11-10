/*
 * University of Helsinki
 * Department of Computer Science
 * 582201 Human-Computer Interaction
 * Autumn 2016
 * Assignment 1: Improvement of the interaction of a website
 * Copyright of this assignment: (c) Antti Salovaara, antti.salovaara@helsinki.fi
 * Modified by Peter Ivanics, peter.ivanics@helsinki.fi
 */
$(document).ready(function() {
  var $citiesDropdown = $("#cities");
  backendsimulator.getCities(function(cityList) { 
      $citiesDropdown.empty();
      $citiesDropdown.append("<option disabled selected>Please select...</option>");
      loadCitiesToDropdown(cityList);
  });

  function loadCitiesToDropdown(cityList) {
      $.each(cityList, function(index, value) {
        $citiesDropdown.append("<option value=\"" + value +  "\">" + value + "</option>");
      });
  };

  $("#submit").click( function() {
    var contentsAreValid = true; // TODO add form validation
    if (contentsAreValid) {
        alert("Thanks for your input!");
    } else {
      alert("Oops, it seems like something is wrong! Please review the form and submit again");
    }
  });
});
