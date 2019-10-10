import mysql.connector
from ConexionBD import ConexionBD

class GestorExamenDAO(ConexionBD):
    def __int__(self):
        pass
    """
    entradas:
        -descripcion: descripcion de la pregunta
        -respuestas(tupla): (descripcion,esCorrecto)
            -descripcion: lo que dice la respuesta
            -esCorrecto: si la respuesta es correcta, valores 0 o 1
    """
    def agregarPregunta(self, descripcion, respuestas):
        try:
            self.crearConexion()
            self._micur.execute("insert into pregunta(descripcion) values (%s)",(descripcion,))
            idpregunta = self._micur.lastrowid
            queryRespuestas="insert into respuestamodelo(idpregunta,descripcion,esCorrecta) values (%s,%s,b'%s')"
            for resp in respuestas:
                self._micur.execute(queryRespuestas,(idpregunta,resp[0],resp[1]))
            self._bd.commit()

        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))

        finally:
            self.cerrarConexion()

if __name__ == '__main__':
    ge = GestorExamenDAO()
    ge.agregarPregunta("primera pregunta",(("primera respuesta",1),("segunda respuesta",1)))