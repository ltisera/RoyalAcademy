$(document).ready(function(){

    $("#selMateria" ).change(cambiador);

    $("#selMateria").append(new Option("Seleciona una materia", 0));
    $.ajax({
        url: 'traerListaMaterias',
        type: 'POST',
        success:function(response){
            console.log("inicio");
            for(var i in response){
                
                console.log("nommbre: " + response[i].nombre);
                console.log("idMateria: " + response[i].idMateria);
                $("#selMateria").append(new Option(response[i].nombre, response[i].idMateria));
                $("#selMateria1").append(new Option(response[i].nombre, response[i].idMateria));
            };
            console.log("fin");

        },
        error:function(response){console.log("MAL")}
    });

    $("#enviarPregunta").click( function() {
        $.post("postPregunta",$("#formPregunta").serialize(),function(res){
            $("#divCrearPregunta").fadeOut("slow");
            if(res!=0){
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
        });
    });
    $("#enviarExamenAuto").click( function() {
        
        $.post("PostExamenAutomatico",$("#formExamenAuto").serialize(),function(res){
            $("#formExamenAuto").fadeOut("slow");
            if(res!=0){
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

function cambiador(){
    console.log("id de materia: " +  $("#selMateria" ).val());
    $.ajax({
        url: 'traerPreguntasDeMateria',
        type: 'POST',
        data:{'idMateria': $("#selMateria" ).val()},
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

$(document).on('click', "#idBtnCrearExamenManual", function() {
    
    var idMateria = $("#selMateria" ).val();
    var lstPreguntas = "["
    var fechaExamen = $("#idFechaDeExamen").val();
    /*{"preguntas":[111,121,123],"fecha":"09/25/1254","idMateria":1} */
    console.log("CREALO NO SEAS VAGOOO")
    $(".clsChkPreguntaExamen").each(function(){
        if($(this).prop('checked')){
            lstPreguntas = lstPreguntas + this.id.substring(10) + ","
        }
    });
    
    lstPreguntas = lstPreguntas.substring(0,lstPreguntas.length-1);
    lstPreguntas = lstPreguntas + "]" 
    var miJson = '{"preguntas":' + lstPreguntas + ',"fecha":"'+fechaExamen+'","idMateria":'+idMateria+'}'
    console.log("Asi quedo Json")
    console.log(miJson)
    $.ajax({
        url: 'crearExamenManual',
        type: 'Post',
        contentType: 'application/json',
        data: JSON.stringify(miJson),
        success: function(response){console.log("Habemus Examen")},
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