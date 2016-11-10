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
  // In your code, you can use this call to validate that the user's input in City field is valid.
  // backendsimulator.cityExists("helsinki", function(result) {
  //   alert("Callback function called, answer is: " + result);
  // });
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

  // click(): The commands within this function are run when the given #id is clicked:
  // See https://api.jquery.com/click/
  $("#submit").click( function() {
    var contentsAreValid = true;
    if (contentsAreValid) {
        alert("Thanks for your input!\n\n(This is the text that user should see if s/he has given valid content to all the fields in this form. Remove this text in the parentheses.)");
    }
  });
});
