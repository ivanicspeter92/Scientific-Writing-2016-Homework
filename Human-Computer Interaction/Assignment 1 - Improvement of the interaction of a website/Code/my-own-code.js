/*
 * University of Helsinki
 * Department of Computer Science
 * 582201 Human-Computer Interaction
 * Autumn 2016
 * Assignment 1: Improvement of the interaction of a website
 * Copyright of this assignment: (c) Antti Salovaara, antti.salovaara@helsinki.fi
 * Modified by Peter Ivanics, peter.ivanics@helsinki.fi
 */

 /*
  * This JavaScript code uses jQuery. All functions that have "$" are jQuery functions.
  * Learn about JavaScript here: http://www.w3schools.com/js/default.asp
  * Learn about jQuery here: http://jquery.com and http://www.w3schools.com/jquery/default.asp
  *
  * Feel free to add more 3rd party JavaScript libraries (in addition to jQuery) if you want!
  */

/* ready():
 * Commands within this function are launched when the browser has fully
 * loaded the contents of the page
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
    var contentsAreValid = true;
    if (contentsAreValid) {
        alert("Thanks for your input!");
    } else {
      alert("Oops, it seems like something is wrong! Please review the form and submit again");
    }
  });
});
