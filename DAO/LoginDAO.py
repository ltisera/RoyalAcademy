from flask import session

from DAO.ConexionBD import ConexionBD
from DAO.Usuario import Usuario
from mysql.connector import Error

class LoginDAO(ConexionBD):
    """docstring for ClassName"""
    def __init__(self):
        pass

    def iniciarSesion(self, username, password):
        usrRespuesta = None
        try:
            self.crearConexion()
            if self._bd.is_connected():
                self._micur.execute('SELECT * FROM usuario WHERE email = %s AND password = %s', (username, password))
                usuario = self._micur.fetchone()
                if(usuario is not None):
                    usrRespuesta = {}
                    usrRespuesta['loggedin'] = True
                    usrRespuesta['id'] = usuario[0]
                    usrRespuesta['username'] = usuario[1]
                    usrRespuesta['tipoUsuario'] = usuario[3]
        except Error as e:
            print("Error al conectar con la BD", e)
        finally:
            self.cerrarConexion()
        return usrRespuesta

    def traerUsuario(self, idUsuario):
        try:
            self.crearConexion()
            if self._bd.is_connected():
                self.cursorDict()
                self._micur.execute('SELECT idUsuario, email, idCarrera FROM usuario WHERE idUsuario = %s', (idUsuario,))
                usuario = self._micur.fetchone()
        except Error as e:
            print("Error al conectar con la BD", e)
        finally:
            self.cerrarConexion()
        return usuario

        