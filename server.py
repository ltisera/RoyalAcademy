import sys

sys.path.append(r'D:\DropBox\Dropbox\FAcultad\proyecto de software\RoyalAcademy\RoyalAcademy\DAO')
sys.path.append(r'C:\Users\Camila\Documents\GitHub\odbcViajes')

#from DAO.pasajeroDAO import PasajeroDAO
from flask import Flask, render_template, send_from_directory, request, jsonify, Response , redirect , url_for, session
from DAO.LoginDAO import LoginDAO
from DAO.AlumnoDAO import AlumnoDAO
from DAO.gestorExamenDAO import GestorExamenDAO
import json

app = Flask(__name__, static_folder='static', static_url_path='')

app.secret_key = 'as654fasd65fg651asd'


# Index

@app.route('/', methods=['GET', 'POST'])
def index():
    if 'username' in session:
        return redirect(url_for('alumno'))
    return render_template('index.html')

#-------------VISTA ALUMNO-----------------------------------------
@app.route('/alumno', methods=['GET'])
def alumno():
    if not 'username' in session:
        return redirect(url_for('index'))
    return render_template('alumno.html')


@app.route('/alumno/navInscribirse', methods=['POST'])
def navInscribirse():
    alumnoDao = AlumnoDAO()
    print("ssssssssssssssss ",json.loads(request.values["carreras"]))
    return jsonify(alumnoDao.traerExamenesDisponibles(request.values["idUsuario"], json.loads(request.values["carreras"]))), 200

@app.route('/alumno/navInscribirse/inscribirseAExamen', methods=['POST'])
def inscribirseAExamen():
    alumnoDao = AlumnoDAO()
    return jsonify(alumnoDao.inscripcionAExamen(request.values['idExamen'], request.values['idUsuario'])), 200

@app.route('/alumno/navRendirExamen', methods=['POST'])
def navRendirExamen():
    alumnoDao = AlumnoDAO()
    return jsonify(alumnoDao.traerExamenesARendir(request.values["idUsuario"])), 200

@app.route('/alumno/navRendirExamen/rendirExamen', methods=['POST'])
def rendirExamen():
    alumnoDao = AlumnoDAO()
    return jsonify(alumnoDao.rendirExamen(request.values["idExamen"])), 200

@app.route('/alumno/navRendirExamen/rendirExamen/responderPregunta', methods=['POST'])
def responderPregunta():
    print("ENTRO AL RESPONDER PREGUNTAS DEL SERVER, ESTO ES LO QUE ME LLEGA: ", json.loads(request.values["respuestas"]))
    alumnoDao = AlumnoDAO()
    alumnoDao.responderPregunta(request.values["idUsuario"], json.loads(request.values["respuestas"]), request.values["idExamen"])
    return jsonify(200)

@app.route('/alumno/navRendirExamen/rendirExamen/finalizarExamen', methods=['POST'])
def finalizarExamen():
    alumnoDao = AlumnoDAO()
    alumnoDao.finalizarExamen(request.values["idUsuario"], request.values["idExamen"])
    return jsonify(200)    

@app.route('/alumno/navConsultarInscripciones', methods=['GET'])
def navConsultarInscripciones():
    alumnoDa0 = AlumnoDAO()
    return jsonify(alumnoDa0.consultarInscripciones(request.values["idUsuario"])), 200
#-------------FIN VISTA ALUMNO-------------------------------------

@app.route('/docente', methods=['GET'])
def docente():
    return render_template('profesor.html')


@app.route('/ag', methods=['GET'])
def ag():
    return render_template('alumno.html')    


@app.route('/registro', methods=['GET'])
def registro():
    return render_template('registro.html') 

# Otros

@app.route('/static/<path:path>')
def sirveDirectorioSTATIC(path):
    sPath = path.split("/")
    directorio = ""
    if(len(sPath) == 1):
        directorio = ""
        arc = sPath[len(sPath) - 1]
    else:
        for i in range(len(sPath) - 1):
            directorio = directorio + sPath[i] + "/"
        directorio = directorio[0:- 1]
        arc = sPath[len(sPath) - 1]
    directorio = "static/" + directorio
    return send_from_directory(directorio, arc)

@app.route('/PostExamenAutomatico', methods=['GET', 'POST'])
def PostExamenAutomatico():
    fecha=request.values['calendar'] + " " + request.values['calendarTime']
    carrera =request.form['carrera']
    gedao = GestorExamenDAO()
    respuesta = gedao.crearExamenAutomatico(fecha,carrera)
    print('----------1-----------------------------------------')
    print(carrera)
    print('----------2-----------------------------------------')
    print(fecha)
    return jsonify(respuesta),200


@app.route('/traerListaCarreras', methods=['GET', 'POST'])
def traerListaCarreras():
    gedao = GestorExamenDAO()
    lCarreras = gedao.traerCarreras()
    print("PARA ESTAR SEGURO")
    print(lCarreras)
    return jsonify(lCarreras),200

@app.route('/traerPreguntasDeCarrera', methods=['GET', 'POST'])
def traerPreguntasDeCarrera():
    gedao = GestorExamenDAO()
    print("Por si las moscas: ", request.values["idCarrera"])
    lPreguntas = gedao.traerPreguntas(request.values["idCarrera"])
    print("PARA ESTAR SEGURO")
    print(lPreguntas)
    return jsonify(lPreguntas),200


@app.route('/postPregunta', methods=['GET', 'POST'])
def postPregunta():
    descripcion = request.form['descripcion']
    respuestas1 = request.form.getlist('respuesta')
    respuestas1.remove(respuestas1[len(respuestas1) - 1])
    respuestas2 = []
    examenDao = GestorExamenDAO()
    carrera = request.form['carrera']
    for x in range(len(respuestas1)):
        if (respuestas1[x].strip() is not ""):
            try:
                if request.form["valor" + str(x + 1)] == "on":
                    respuestas2.append((respuestas1[x], 1))
            except:
                respuestas2.append((respuestas1[x], 0))
    respuesta = examenDao.agregarPregunta(descripcion, carrera, respuestas2)
    return jsonify(respuesta), 200

@app.route('/favicon.ico', methods=['GET'])
def devolveFavicon():
    print("CACHEO")
    return send_from_directory("static/img", "favicon.ico")

@app.route('/login', methods=['GET', 'POST'])
def login():
    ldao = LoginDAO()
    if request.method == 'POST' and 'email' in request.form and 'password' in request.form:
        usuarioDevuelto = ldao.iniciarSesion(request.form['email'], request.form['password'])
        print(usuarioDevuelto)
        session['username'] = usuarioDevuelto['id']
        if(usuarioDevuelto):
            if(usuarioDevuelto['tipoUsuario'] == 'alumno'):
                return redirect(url_for('alumno'))
            if(usuarioDevuelto['tipoUsuario'] == 'profesor'):
                return redirect(url_for('docente'))
            if(usuarioDevuelto['tipoUsuario'] == 'ag'):
                return redirect(url_for('ag'))
        else: 
            return redirect(url_for('registro'))
        
                
    return jsonify(usuarioDevuelto),200


@app.route('/logout', methods=['GET', 'POST'])
def logout():
    session.pop('username', None)
    return redirect(url_for('index'))

@app.route('/getUser', methods=['GET', 'POST'])
def getUser():
    print("El session esta cargado con esto: ", session)
    logindao = LoginDAO()
    return jsonify(logindao.traerUsuario(session['username']))

@app.route('/crearExamenManual',methods=['GET','POST'])
def crearPregunta():
    geDAO = GestorExamenDAO()
    datos = json.loads(request.json)
    
    resultado = geDAO.crearExamenManual(datos["fecha"], 1, datos["idCarrera"], datos["preguntas"])
    return jsonify(resultado),200

@app.route('/traerExamenesDeCarrera', methods=['GET', 'POST'])
def traerExamenesDeCarrera():
    geDAO = GestorExamenDAO()
    rExamenes = geDAO.traerExamenes(request.values['idCarrera'])
    return jsonify(rExamenes), 200

@app.route('/traerAlumnosDeExamen', methods=['GET', 'POST'])
def traerAlumnosDeExamen():
    geDAO = GestorExamenDAO()
    rAlumnos = geDAO.traerAlumosDeExamenConNota(request.values['idExamen'])

    return jsonify(rAlumnos), 200


@app.route('/cargarNotaPractica', methods=['GET', 'POST'])
def cargarNotaPractica():
    geDAO = GestorExamenDAO()
    idExamen = request.values["idExamen"]
    idUsuario = request.values["idUsuario"]
    notaPractico = request.values["notaPractico"]
    larta = geDAO.ingresarNotaPracticaDeAlumno(idExamen,idUsuario,notaPractico)
    return jsonify(larta), 200


@app.route('/cerrarExamen', methods=['GET', 'POST'])
def cerrarExamen():
    geDAO = GestorExamenDAO()
    idExamen = request.values["idExamen"]
    larta = geDAO.finalizarExamen(idExamen)
    return jsonify(larta), 200


@app.route('/traerListaExamenesCarrera', methods=['GET', 'POST'])
def traerListaExamenesCarrera():
    geDAO = GestorExamenDAO()
    lExamenes = geDAO.traerExamenes(request.values["idCarrera"])
    return jsonify(lExamenes), 200


@app.route('/traerListaExamenesAbiertosCarrera', methods=['GET', 'POST'])
def traerListaExamenesAbiertosCarrera():
    geDAO = GestorExamenDAO()
    lExamenes = geDAO.traerExamenesAbiertos(request.values["idCarrera"])
    return jsonify(lExamenes), 200

####Fin de rutas
app.run(debug=True)
