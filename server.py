import sys

sys.path.append(r'D:\DropBox\Dropbox\FAcultad\proyecto de software\RoyalAcademy\RoyalAcademy\DAO')
sys.path.append(r'C:\Users\Camila\Documents\GitHub\odbcViajes')

#from DAO.pasajeroDAO import PasajeroDAO
from flask import Flask, render_template, send_from_directory, request, jsonify, Response , redirect , url_for
from DAO.LoginDAO import LoginDAO
from DAO.gestorExamenDAO import GestorExamenDAO
import json
app = Flask(__name__, static_folder='static', static_url_path='')



# Index

@app.route('/', methods=['GET', 'POST'])
def index():
    return render_template('index.html')


@app.route('/alumno', methods=['GET'])
def alumno():
    return render_template('alumno.html')


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


@app.route('/traerListaMaterias', methods=['GET', 'POST'])
def traerListaMaterias():
    gedao = GestorExamenDAO()
    lMaterias = gedao.traerMaterias(1)
    print("PARA ESTAR SEGURO")
    print(lMaterias)
    return jsonify(lMaterias),200

@app.route('/traerPreguntasDeMateria', methods=['GET', 'POST'])
def traerPreguntasDeMateria():
    gedao = GestorExamenDAO()
    print("Por si las moscas: ", request.values["idMateria"])
    lMaterias = gedao.traerPreguntas(request.values["idMateria"])
    print("PARA ESTAR SEGURO")
    print(lMaterias)
    return jsonify(lMaterias),200

@app.route('/crearPregunta',methods=['GET','POST'])
def crearPregunta():
    print("A ver a ver")
    abc = json.loads(request.json)
    
    print("Completo")
    print(abc)
    print("Pregunta")
    
    print(abc["pregunta"])
    print("Accedo a la lista")
    for l in abc["lista"]:
        print("AbcRespuesta: ", l["respuesta"])
    
    return jsonify(""),200

@app.route('/postPregunta',methods=['GET','POST'])
def postPregunta():
    descripcion = request.form['descripcion']
    respuestas1=request.form.getlist('respuesta')
    respuestas2 = []
    examenDao = GestorExamenDAO()
    for x in range(len(respuestas1)):
        try:
            if request.form["valor"+str(x+1)] == "on":
                respuestas2.append((respuestas1[x],1))
        except:
            respuestas2.append((respuestas1[x],0))
    examenDao.agregarPregunta(descripcion,"matematica",respuestas2)


@app.route('/login', methods=['GET', 'POST'])
def login():
    ldao = LoginDAO()
    if request.method == 'POST' and 'email' in request.form and 'password' in request.form:
        usuarioDevuelto = ldao.iniciarSesion(request.form['email'], request.form['password'])
        
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

app.run(debug=True)
