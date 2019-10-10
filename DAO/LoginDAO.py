from flask import session

from DAO.ConexionBD import ConexionBD
from DAO.Usuario import Usuario
from mysql.connector import Error

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
        except Error as e:
            print("Error al conectar con la BD", e)
        finally:
            self.cerrarConexion()
            return (usuario,session)

        