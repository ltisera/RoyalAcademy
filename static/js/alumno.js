var alumno;
var listaPreguntas;
var contadorDePreguntas;
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
          html+="<div class='card w-100'><div class='card-body'><h5 class='card-title'>"+response[i].materia+"</h5><p class='card-text'>"+response[i].fecha+"</p><a class='btn btn-primary' href='#' id='inscribirse"+response[i].idExamen+"' onclick='inscribirseAExamen("+response[i].idExamen+")'>Inscribirse</a></div></div>"
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

function traerExamenesARendir(){
  $.ajax({
    url:"alumno/navRendirExamen",
    type: "POST",
    data: alumno,
    success: function(response){

      console.log("traigo examenes a rendir "+response);
      
      var html ="";
      for(var i=0;i<response.length;i++){
        html+="<div class='card w-100'><div class='card-body'><h5 class='card-title'>"+response[i].materia+"</h5><p class='card-text'>"+response[i].fecha+"</p><a class='btn btn-primary' href='#' id='rendir"+response[i].idExamen+"' onclick='rendirExamen("+response[i].idExamen+")'>Comenzar Examen</a></div></div>"       
      }
      document.getElementById("navrendirdiv").innerHTML= html;
    },
    error:function(response){
      console.log("Error")
    } 
  });
}


function rendirExamen(idExamen){
  $.ajax({
    url:"alumno/navRendirExamen/rendirExamen",
    type: "POST",
    data: {"idExamen":idExamen},
    success: function(response){
      console.log("Rendi el examen ",response)
      $(".content").hide();
      

      listaPreguntas = response;
      contadorDePreguntas = 0;
      mostrarPregunta();
    },
    error: function(response){
      console.log("ERROR");
    }
  });
}

function mostrarPregunta(){
  var html="<div class='card w-100'><div class='card-body'><h5 class='card-title'>"+listaPreguntas[contadorDePreguntas].descripcion+"</h5><div class='form-check'>";
  for(var i=0;i<listaPreguntas[contadorDePreguntas].respuestas.length;i++){
    html+="<div><input class='form-check-input' type='checkbox' value='"+listaPreguntas[contadorDePreguntas].respuestas[i].idRespuesta+"'><label class='form-check-label'>"+listaPreguntas[contadorDePreguntas].respuestas[i].descripcion+"</label></div>";
  }  
  if(contadorDePreguntas==listaPreguntas.length-1){
    html+="</div><button type='submit' href='#' class='btn btn-primary' onclick='traerExamenesARendir()'>Finalizar examen</button></div>";
  }
  else{
    html+="</div><button type='submit' href='#' class='btn btn-primary' onclick='mostrarPregunta()'>Siguiente pregunta</button></div>";
  }
  contadorDePreguntas++;
  document.getElementById("examenARendirdiv").innerHTML = html;
  $(".exmn").show();
}