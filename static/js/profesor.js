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
            };
            console.log("fin");

        },
        error:function(response){console.log("MAL")}
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