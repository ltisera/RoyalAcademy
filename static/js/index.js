$(document).ready(function(){
    console.log("INDICE")
    
});

$(document).on('click', "#idLogueate", function() {
    $.post("login", $("#loginform").serialize(), function(response){
        var resultado = response;
			switch(resultado){
			case '1':
				console.log("soy un alumno, redireccion")
				window.location.href = "alumno";
				break;
			case '2':
				window.location.href = "docente";
				break
			default:
				$("#respuestalogin").html(resultado)
				break;
			}
    });
});