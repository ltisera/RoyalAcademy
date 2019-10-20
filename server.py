import sys

sys.path.append(r'D:\DropBox\Dropbox\FAcultad\proyecto de software\RoyalAcademy\RoyalAcademy\DAO')
sys.path.append(r'C:\Users\Camila\Documents\GitHub\odbcViajes')

#from DAO.pasajeroDAO import PasajeroDAO
from flask import Flask, render_template, send_from_directory, request, jsonify, Response , redirect , url_for, session
from DAO.LoginDAO import LoginDAO
from DAO.AlumnoDAO import AlumnoDAO

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
    return jsonify(alumnoDao.traerExamenesDisponibles(request.values["idUsuario"], request.values["idCarrera"])), 200

@app.route('/alumno/navInscribirse/inscribirseAExamen', methods=['POST'])
def inscribirseAExamen():
    alumnoDao = AlumnoDAO()
    return jsonify(alumnoDao.inscripcionAExamen(request.values['idExamen'], request.values['idUsuario'])), 200
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
    logindao = LoginDAO()
    return jsonify(logindao.traerUsuario(session['username']))

app.run(debug=True)
