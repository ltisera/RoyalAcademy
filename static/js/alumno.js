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
      data: {"idUsuario":1,"idCarrera":1},
      success: function(response){
        console.log(response);
        
        var html ="";
        var navInscribirse = document.getElementById("navinscribirsediv");
        for(var i=0;i<response.length;i++){
          html+="<div class='card w-100'><div class='card-body'><h5 class='card-title'>"+response[i].materia+"</h5><p class='card-text'>"+response[i].fecha+"</p><a href='#' class='btn btn-dark'>Inscribirse</a></div></div>"
        }
        navInscribirse.innerHTML= html;
      },
      error:function(response){
        console.log("MAL")
      } 
    });
    /*
    var listaExamenes = new XMLHttpRequest();
    listaExamenes.open("POST", "/alumno/navInscribirse");
    
    listaExamenes.onload = function(){
      var examenes =  JSON.parse(this.responseText);*/

      /*
      var html ="";
      var navInscribirse = document.getElementById("navinscribirsediv");
      for(var i=0;i<examenes.length;i++){
        html+="<div class='card w-100'><div class='card-body'><h5 class='card-title'>"+examenes[i].materia+"</h5><p class='card-text'>"+examenes[i].fecha+"</p><a href='#' class='btn btn-dark'>Inscribirse</a></div></div>"
      }
      navInscribirse.innerHTML= html;

      */
    }
    /*
    listaExamenes.onreadystatechange = function() {
        var examenes =  JSON.parse(this.responseText);
        console.log(examenes);
      };*/

      //listaExamenes.send();



