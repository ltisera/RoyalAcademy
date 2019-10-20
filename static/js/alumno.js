var alumno;
//ajax para traer el usuario completo
$.ajax({
  url:"getUser",
  type: "GET",
  success: function(response){
    console.log("traigo el usuario")
    console.log(response);
    alumno = response;
  },
  error:function(response){
    console.log("Error")
  } 
});




$(function() {
    $(".nav-link").on("click",function(e) {
      e.preventDefault();
      $(".content").hide();
      $("#"+this.id+"div").show();
    });
  });

function traerExamenesDisponibles(){
    $.ajax({
      url:"alumno/navInscribirse",
      type: "POST",
      data: alumno,
      success: function(response){

        console.log(response);
        
        var html ="";
        var navInscribirse = document.getElementById("navinscribirsediv");
        for(var i=0;i<response.length;i++){
          html+="<div class='card w-100'><div class='card-body'><h5 class='card-title'>"+response[i].materia+"</h5><p class='card-text'>"+response[i].fecha+"</p><a href='#' class='btn btn-dark' id='inscribirse"+response[i].idExamen+"' onclick='inscribirseAExamen("+response[i].idExamen+")'>Inscribirse</a></div></div>"
      }
      navInscribirse.innerHTML= html;
    },
    error:function(response){
        console.log("MAL")
    } 
  });
}

function inscribirseAExamen(idExamen){
  $.ajax({
    url:"alumno/navInscribirse/inscribirseAExamen",
    type: "POST",
    data: {"idUsuario":alumno['idUsuario'],"idExamen":idExamen},
    success: function(response){
      console.log("se inscribio!")
      console.log(response);
      document.getElementById("inscribirse"+idExamen).style.display = 'none';
      
    },
  error:function(response){
      console.log("Error");
  } 
});
}


