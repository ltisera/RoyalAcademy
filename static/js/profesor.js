$(document).ready(function(){

    $("#selCarrera" ).change(cambiador);

    console.log("DALE PUTO")
    $.ajax({
        url: 'traerListaMaterias',
        type: 'POST',
        success:function(response){
            console.log("inicio");
            for(var i in response){
                
                console.log("nommbre: " + response[i].nombre);
                console.log("idMateria: " + response[i].idMateria);
                $("#selCarrera").append(new Option(response[i].nombre, response[i].idMateria));
                $("#selCarrera1").append(new Option(response[i].nombre, response[i].idMateria));
            };
            console.log("fin");

        },
        error:function(response){console.log("MAL")}
    });

    $("#enviarPregunta").click( function() {
        $.post("postPregunta",$("#formPregunta").serialize(),function(res){
            console.log(res);
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
                console.log("pruebaaa");
                $("#respEnviarPregunta").fadeOut("slow");
                $("#divCrearPregunta").delay(500).fadeIn("slow");
            });
        });
    });

    
});

function cambiador(){
    console.log("id de materia: " +  $("#selCarrera" ).val());
    $.ajax({
        url: 'traerPreguntasDeMateria',
        type: 'POST',
        data:{'idMateria': $("#selCarrera" ).val()},
        success:function(response){
            console.log(response);
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