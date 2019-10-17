$(document).ready(function(){
    console.log("INDICE")
    $.ajax({
        url: 'traerListaMaterias',
        type: 'POST',
        success:function(response){
            console.log("inicio");
            for(var i in response){
                console.log("PASO");
                console.log(i);
            };
            console.log("fin");

        },
        error:function(response){console.log("MAL")}
    });
});

$(document).on('click', "#idLogueate", function() {
    $.ajax({
        url: 'login',
        type: 'POST',
        data: {"username": $("#idTxtUssr").val(),
                "password": $("#idTxtPass").val()
            },
        success:function(response){console.log(response)},
        error:function(response){console.log("MAL")}
    });
});