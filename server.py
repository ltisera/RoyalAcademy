import sys

sys.path.append(r'D:\DropBox\Dropbox\FAcultad\proyecto de software\RoyalAcademy\RoyalAcademy\DAO')
sys.path.append(r'C:\Users\Camila\Documents\GitHub\odbcViajes')

#from DAO.pasajeroDAO import PasajeroDAO
from flask import Flask, render_template, send_from_directory, request, jsonify, Response , redirect , url_for
from DAO.LoginDAO import LoginDAO

app = Flask(__name__, static_folder='static', static_url_path='')



# Index

@app.route('/', methods=['GET', 'POST'])
def index():
    return render_template('login.html')


@app.route('/holaEnzo', methods=['GET', 'POST'])
def traerCiudades():
    return jsonify("HolaEnzo"), 200


@app.route('/alumno', methods=['GET'])
def alumno():
    return render_template('alumno.html')

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

@app.route('/login', methods=['GET', 'POST'])
def login():
    ldao = LoginDAO()
    print("DBGGGGGGGG")
    print(request.form)
    print("DBG END")
    
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        print("Estoy entrando wacxhoooo")
        usuarioDevuelto = ldao.iniciarSesion(request.form['username'], request.form['password'])
        
        if(usuarioDevuelto):
            if(usuarioDevuelto['tipoUsuario'] == 'alumno'):
                return redirect(url_for('alumno'))
            if(usuarioDevuelto['tipoUsuario'] == 'profesor'):
                print('se logueo profesor')
            if(usuarioDevuelto['tipoUsuario'] == 'ag'):
                print('se logueo admin general')    
        else: 
            print('no se encuentra registrado. Por favor registrarse')
        
                
    return jsonify(usuarioDevuelto),200

app.run(debug=True)
