from flask import session

from ConexionBD import ConexionBD
from Usuario import Usuario


class LoginDAO(ConexionBD):
    """docstring for ClassName"""
    def __init__(self):
        pass

    def iniciarSesion(self, username, password):
        usuario = Usuario()
        try:
            self.crearConexion()
            if self._bd.is_connected():
                self._micur.execute('SELECT * FROM usuario WHERE email = %s AND password = %s', (username, password))
                usuario = self._micur.fetchone()
                if usuario:
                    session['loggedin'] = True
                    session['id'] = usuario['idUsuario']
                    session['username'] = usuario['email']
        except mysql.connector.errors.IntegrityError as e:
            print("Error al conectar con la BD", e)
        finally:
            self.cerrarConexion()
            return (usuario,session)

        