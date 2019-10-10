import mysql.connector
from DAO.ConexionBD import ConexionBD

class GestorExamenDAO(ConexionBD):
    def __int__(self):
        pass
    
    def agregarPregunta(self, descripcion, respuestas):
        try:
            self.crearConexion()
            self._micur.execute("insert into pregunta(descripcion) values (%s)",descripcion)
            idpregunta = self._micur.lastrowid
            queryRespuestas="insert into respuesta(idpregunta,descripcion,esCorrecta) values (%s,%s,b'%s')"
            for resp in respuestas:
                self._micur.execute(queryRespuestas,(idpregunta,resp[0],resp[1]))
            self._bd.commit()

        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))

        finally:
            self.cerrarConexion()

