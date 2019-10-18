$(document).ready(function(){
    console.log("INDICE")
    
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