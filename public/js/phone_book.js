function searchfunk() {
    var input, filter, table, tr, td, i;
    input = document.getElementById("searchinput");
    filter = input.value.toUpperCase();
    table = document.getElementById("table");
    tr = table.getElementsByTagName("tr");
    for (i = 0; i < tr.length; i++) {
      td = tr[i].getElementsByTagName("td")[0];
      if (td) {
        if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
          tr[i].style.display = "";
        } else {
          tr[i].style.display = "none";
        }
      }       
    }
}


function disableButton(){
  var dash = document.getElementById("dash");
  var x = document.getElementById("fname");
  var y = document.getElementById("lname");
  var z = document.getElementById("pnum");
  var g = document.getElementById("strtadd");
  var h = document.getElementById("city");
  var l = document.getElementById("state");
  var k = document.getElementById("zip"); 
  var counter = 0;
  var arr = [x, y, z, g, h, l, k];

  for (var d = 0; d < arr.length; d++){
    if (arr[d].value.length > 1) {
      counter++;
    };
    if (counter == 6) {
      document.getElementById("disable").disabled = "disabled";
      dash.submit();

    };
  }
}

