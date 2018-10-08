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
 document.getElementById("disable").disabled = "disabled";
    dash.submit();
}

