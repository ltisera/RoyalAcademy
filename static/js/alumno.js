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
      console.log("rindo examen Y ME ASEGURO ",response)
      $(".content").hide();
      console.log("ALGO:" + listaPreguntas)
      listaPreguntas = response[0];
      console.log(listaPreguntas)
      contadorDePreguntas = response[1].progreso;
      console.log("Mi listaPreguntas: ", listaPreguntas);
      
      console.log("Mi contadorDePreguntas: ", contadorDePreguntas);
      console.log("muestro primer pregunta");
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
    html+="<div><input class='form-check-input' type='checkbox' value='"+listaPreguntas[contadorDePreguntas].respuestas[i].idRespuesta+"' name='resp'><label class='form-check-label'>"+listaPreguntas[contadorDePreguntas].respuestas[i].descripcion+"</label></div>";
  }  
  if(contadorDePreguntas==listaPreguntas.length-1){
    html+="</div><button type='submit' id='sgtePreg href='#' class='btn btn-primary' onclick='sgtePregunta()'>Finalizar examen</button></div>";
  }
  else{
    html+="</div><button type='submit' id='sgtePreg' href='#' class='btn btn-primary' onclick='sgtePregunta()'>Siguiente pregunta</button></div>";
  }
  document.getElementById("examenARendirdiv").innerHTML = html;
  $(".exmn").show();
}

function sgtePregunta(){
  console.log("SIGUIENTE PREGUNTA");
  var respuestas = [];
  $(":checkbox[name=resp]").each(function(){
    if (this.checked){
      respuestas.push($(this).val());
    }
  });
  console.log("Lista de respuestas ",respuestas);
  if(respuestas.length>0){
    console.log("llamo a responderPregunta, contador = ",contadorDePreguntas);
    responderPregunta(respuestas);
  } else{
    alert('Debes seleccionar al menos una respuesta.');
  }
}

function responderPregunta(respuestas){
  var objeto = {"idUsuario":alumno["idUsuario"], "respuestas":JSON.stringify(respuestas),"idExamen":listaPreguntas[contadorDePreguntas]["idExamen"]};
  console.log("Esto es lo que envio al respodnerPregunta: ", objeto);
  
  
  $.ajax({
    url:"alumno/navRendirExamen/rendirExamen/responderPregunta",
    type: "POST",
    data: objeto,
    success: function(response){
      console.log("Respuestas enviadas");  
      if(contadorDePreguntas==listaPreguntas.length-1){
        finalizarExamen();
        console.log("Finalize el examen");
      }else{
        contadorDePreguntas++;
        console.log("muestro primer pregunta");
        mostrarPregunta();
      }
      mostrarPregunta();
    },
    error: function(response){
      console.log("ERROR");
    }
  });
}

function finalizarExamen(){
  $.ajax({
    url:"alumno/navRendirExamen/rendirExamen/finalizarExamen",
    type: "POST",
    data: {"idUsuario":alumno.idUsuario, "idExamen":listaPreguntas[0].idExamen},
    success: function(response){
      console.log("Examen finalizado");
      contadorDePreguntas=0;
      listaPreguntas="";     
      
    },
    error: function(response){
      console.log("ERROR");
    }
  });
}