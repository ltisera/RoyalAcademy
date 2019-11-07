/* login y session */
var usuario;
//ajax para traer el usuario completo
$.ajax({
  url:"getUser",
  type: "GET",
  success: function(response){
    console.log("traigo el usuario")
    console.log(response);
    usuario = response;
    $("#nombreusuario").html(usuario.email)
  },
  error:function(response){
    console.log("Error")
  } 
});


/* login y session */
$(document).ready(function(){

    $("#selCarrera").change(cambiador);
    $("#selCarrera2").change(traerExamenesCarrera);
    $("#selExamen2").change(traerAlumnosCarrera);
    
    $("#selCarrera").append(new Option("Seleciona una carrera", 0));
    $("#selCarrera2").append(new Option("Seleciona una carrera", 0));
    
    $.ajax({
        url: 'traerListaCarreras',
        type: 'POST',
        success:function(response){
            console.log("inicio");
            for(var i in response){
                
                console.log("nommbre: " + response[i].nombre);
                console.log("idCarrera: " + response[i].idCarrera);
                $("#selCarrera").append(new Option(response[i].nombre, response[i].idCarrera));
                $("#selCarrera1").append(new Option(response[i].nombre, response[i].idCarrera));
                $("#selCarrera2").append(new Option(response[i].nombre, response[i].idCarrera));
                $("#selCarreraPregunta").append(new Option(response[i].nombre, response[i].idCarrera));
            };
            console.log("fin");

        },
        error:function(response){console.log("MAL")}
    });

    $("#enviarPregunta").click( function() {
        var hayCorrecta = false;
        var respuestas = $(".clsRta");
        var i = 0;
        var cantRespuestasNoVacias = 0;
        var checkbox = null;
        while(!hayCorrecta && i<respuestas.length){
            checkbox = $("#" + respuestas[i].id).next().find("input")[0];
            console.log($.trim(respuestas[i].value));
            if($.trim(respuestas[i].value) != ""){
                cantRespuestasNoVacias += 1;
                if(checkbox.checked == true){
                    hayCorrecta = true;
                }
            }
            i++;
        }
        while(cantRespuestasNoVacias < 2 && i<respuestas.length){
            if($.trim(respuestas[i].value) != ""){
                cantRespuestasNoVacias += 1;
                if(checkbox.checked == true){
                    hayCorrecta = true;
                }
            }
            i++;
        }
        if(hayCorrecta){
            if(cantRespuestasNoVacias >= 2){
                $.post("postPregunta",$("#formPregunta").serialize(),function(response){
                $("#divCrearPregunta").fadeOut("slow");
                if(response != 0){
                    $("#formPregunta")[0].reset();
                    $("#respEnviarPregunta").html('<h3>Pregunta Agregada</h3><button type="button" id="nuevaPregunta" class="btn btn-primary my-1">Enviar otra pregunta</button>');
                }
                else{
                    $("#respEnviarPregunta").html('<h3>Hubo un error</h3><button type="button" id="nuevaPregunta" class="btn btn-primary my-1">Reintentar</button>');
                }
                $("#respEnviarPregunta").delay(500).fadeIn("slow");
                $("#nuevaPregunta").click( function() {
                    $("#respEnviarPregunta").fadeOut("slow");
                    $("#divCrearPregunta").delay(500).fadeIn("slow");
                });
                $("#idDivRta").html(`<div class="input-group ">
                                        <input type="text" name="respuesta" id="rta1" class="form-control clsRta" aria-label="Text input with checkbox">
                                        <div class="input-group-prepend">
                                            <div class="input-group-text">
                                                <input name="valor1" type="checkbox" aria-label="Checkbox for following text input">
                                            </div>
                                        </div>  
                                    </div>
                                    <br>
                                    <div class="input-group ">
                                            <input type="text" name="respuesta" id="rta2" class="form-control clsRta" aria-label="Text input with checkbox">
                                            <div class="input-group-prepend">
                                                <div class="input-group-text">
                                                    <input name="valor2" type="checkbox" aria-label="Checkbox for following text input">
                                                </div>
                                            </div>  
                                            <br>
                                    </div>
                                    <br>`);
                });
            }else{
                alert("Debe haber al menos 2 respuestas no vacias");
            }
        }else{
            alert("No ha marcado una respuesta no vacia como correcta");
        }
    });

    $("#enviarExamenAuto").click( function() {
        
        $.post("PostExamenAutomatico", $("#formExamenAuto").serialize(), function(response){
            $("#formExamenAuto").fadeOut("slow");
            if(response != 0){
                $("#formExamenAuto")[0].reset();
                $("#respExamenAuto").html('<h3>Examen Creado</h3><button type="button" id="nuevaExamenAuto" class="btn btn-primary my-1">Crear otro examen</button>');
            }
            else{
                $("#respExamenAuto").html('<h3>Hubo un error</h3><button type="button" id="nuevaExamenAuto" class="btn btn-primary my-1">Reintentar</button>');
            }
            $("#respExamenAuto").delay(500).fadeIn("slow");
            $("#nuevaExamenAuto").click( function() {
                $("#respExamenAuto").fadeOut("slow");
                $("#formExamenAuto").delay(500).fadeIn("slow");
            });
        });
    });
    
});

function traerExamenesCarrera(){
    $("#selExamen2").html("");
    $("#selExamen2").append(new Option("Seleciona un Examen", 0));
    $.ajax({
        url: 'traerListaExamenesCarrera',
        type: 'POST',
        data: {"idCarrera" : $("#selCarrera2").val()},
        success:function(response){
            for(var i in response){
                
                console.log("fecha: " + response[i].fecha);
                console.log("idExamen: " + response[i].idExamen);
                $("#selExamen2").append(new Option(response[i].fecha, response[i].idExamen));
            };
            console.log("fin");

        },
        error:function(response){console.log("MAL")}
    });

}
function traerAlumnosCarrera(){
    var idExamen = $("#selExamen2").val()
    $("#idDivNotas").html("");
    var rellenar = ""
    $.ajax({
        url: 'traerAlumnosDeExamen',
        type: 'POST',
        data: {'idExamen':$("#selExamen2").val()},
        success: function(response){
            console.log(response)
            for (i in response){
                rellenar += `
                <div class="clsNotaPracticoAlumnoF`+(i%2 + 1)+`" id="idNotapracticoA1">
                    <div class="clsFL clsNombreAlumno">
                        ` + response[i].idUsuario + `
                    </div>
                    <div class="clsFL clsFechaExamen">
                        `+ response[i].notaExamen +`
                    </div>
                    <div class="clsNota">
                        <input type="text" id="inpNota` + response[i].idUsuario + `" class="clsInputNota">
                    </div>
	
                </div>
                ` 
                console.log("DNI: " + response[i].idUsuario)
                console.log("Nota: " + response[i].notaExamen)
            }
            $("#idDivNotas").html(rellenar);
        },
        error: function(response){
            console.log("BIEN ALUMNOS")
            console.log(response)
        }
    });
    console.log("AXA")
    console.log(rellenar)
    
};
function cambiador(){
    console.log("id de Carrera " +  $("#selCarrera" ).val());
    $.ajax({
        url: 'traerPreguntasDeCarrera',
        type: 'POST',
        data:{'idCarrera': $("#selCarrera" ).val()},
        success:function(response){
            console.log("ESTO QUIERO")
            console.log(response)
            $("#idDivPreguntas").html("")
            for (var i in response){
                console.log(i)
                unaPregunta =` 
                    <div>
                        <label class="clsMarcoPregunta" id="pregunta`+response[i].idPregunta+`">`+response[i].descripcion+`</label>
                        <input class="clsChkPreguntaExamen" id="chPregunta`+response[i].idPregunta+`" type="checkbox">
                    </div>`
                $("#idDivPreguntas").append(unaPregunta)
            }
            
        },
        error:function(response){console.log("MAL ALGO")}
    });
};

$(document).on('focus', ".clsRta", function() {
    
    console.log($(".clsRta:last").attr("id"));
    var i = parseInt(this.id.substring(3)) + 1
    var miHtml = `
    <div class="input-group ">
    <input type="text" id="rta`+i.toString()+`"name="respuesta" class="form-control clsRta" aria-label="Text input with checkbox">
    <div class="input-group-prepend">
          <div class="input-group-text">
            <input name="valor`+i.toString()+`" type="checkbox" aria-label="Checkbox for following text input">
          </div>
    </div>  
</div>
<br>
    
    `;
    if(this.id == $(".clsRta:last").attr("id")){
        console.log("SI SOY")
        $("#idDivRta").append(miHtml);
    }
    else{
        console.log(" NOSOY")
    }
});


$(document).on('click', "#idBtnCargarNotas", function() {
    
    $(".clsInputNota").each(
        function(){

            console.log("id: " + $(this).attr("id").substring(7) + " nota: " + $(this).val() + "idExamen: " + $("#selExamen2").val())
            console.log("llamoAlAjax")
            $.ajax({
                url: 'cargarNotaPractica',
                type: 'POST',
                data: {
                    "idUsuario" : $(this).attr("id").substring(7),
                    "notaPractico" : $(this).val(),
                    "idExamen" : $("#selExamen2").val()
                    },
                success:function(response){console.log("NOTAS Cargadas")},
                error:function(response){console.log("Error al notacargar")}
            });
        });
    /*
    $.ajax({
        url: 'cargarPlanillaNotas',
        type: 'POST',
        data: notasACargar,
        success: function(response){},
        error: function(response){}
    });
    */
});

$(document).on('click', "#idBtnCrearExamenManual", function() {
    
    var idCarrera = $("#selCarrera" ).val();
    var lstPreguntas = "["
    var fechaExamen = $("#idFechaDeExamen").val();
    var horaExamen = $("#idHoraDeExamen").val();
    /*{"preguntas":[111,121,123],"fecha":"09/25/1254","idCarrera":1} */
    console.log("CREALO NO SEAS VAGOOO")
    $(".clsChkPreguntaExamen").each(function(){
        if($(this).prop('checked')){
            lstPreguntas = lstPreguntas + this.id.substring(10) + ","
        }
    });
    
    lstPreguntas = lstPreguntas.substring(0,lstPreguntas.length-1);
    lstPreguntas = lstPreguntas + "]" 
    var miJson = '{"preguntas":' + lstPreguntas + ',"fecha":"'+fechaExamen+ " " +horaExamen+'","idCarrera":'+idCarrera+'}'
    console.log("Asi quedo Json")
    console.log(miJson)
    $.ajax({
        url: 'crearExamenManual',
        type: 'Post',
        contentType: 'application/json',
        data: JSON.stringify(miJson),
        success: function(response){
            $("#divExamenManual").fadeOut("slow");
            if(response != 0){
                $("#selCarrera" ).val(0);
                $("#idFechaDeExamen").val("");
                $("#idHoraDeExamen").val("");
                $("#idDivPreguntas").html("");
                $("#respExamenManual").html('<h3>Examen Agregado</h3><button type="button" id="nuevoExamen" class="btn btn-primary my-1">Crear otro examen</button>');
            }
            else{
                $("#respExamenManual").html('<h3>Hubo un error</h3><button type="button" id="nuevoExamen" class="btn btn-primary my-1">Reintentar</button>');
            }
            $("#respExamenManual").delay(500).fadeIn("slow");
            $("#nuevoExamen").click( function() {
                $("#respExamenManual").fadeOut("slow");
                $("#divExamenManual").delay(500).fadeIn("slow");
            });
        },
        error: function(response){console.log("Habemus Errorus")}
    });
});
/*
$(document).on('click', "#idBtnCrearExamen", function() {
    
    var cuantos = parseInt($(".clsRta:last").attr("id").substring(3));
    /* Me imagino algo asi
        {"pregunta":"perro", [{"resp1":"Herviboro", "correcto":0},{resp1:Correcto},{resp1:Correcto}] }
    var miJson='{"pregunta":"'+$('#idLaPregunta').val()+'","lista":[';
    
    for(var i=1;i < cuantos; i++){
        miJson = miJson + '{"respuesta":"' + $('#rta'+i).val() +'","correcta":';
        if ($('#chk'+i).prop('checked') == true){
            miJson = miJson + '1},';
        }
        else{
            miJson = miJson + '0},';
        }
        
    }
    
    miJson = miJson.substring(0,miJson.length-1);
    miJson = miJson +']}'
    
    console.log(miJson);
    $.ajax({
        url: 'crearPregunta',
        type: 'Post',
        contentType: 'application/json',
        data: JSON.stringify(miJson),
        success: function(response){console.log("Habemus Pregunta")},
        error: function(response){console.log("Habemus Errorus")}
    });
});
*/