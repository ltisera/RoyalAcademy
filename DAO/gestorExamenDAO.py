import mysql.connector
from ConexionBD import ConexionBD

class GestorExamenDAO(ConexionBD):
    def __init__(self):
        pass
    """
    entradas:
        -descripcion: descripcion de la pregunta
        -respuestas(tupla): (descripcion,esCorrecto)
            -descripcion: lo que dice la respuesta
            -esCorrecto: si la respuesta es correcta, valores 0 o 1
    ejemplo:
        agregarPregunta("De que color es el gato",(("blanco",0),("negro",1),("soy Daltonico",0)))
        {{"De que color es el gato"},{{"blanco",0},{"negro",1},{"soy Daltonico",0}}}
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

    """Trae las preguntas pero sin las respuestas"""
    def traerPreguntas(self):
        listaPreguntas = []
        try:
            self.crearConexion()
            self.cursorDict()
            self._micur.execute("select * from pregunta")
            for pregunta in self._micur:
                listaPreguntas.append(pregunta)
        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()
        if len(listaPreguntas)==0:
            listaPreguntas = None
        return listaPreguntas
    
    """ Trae las respuestas de una pregunta """
    def traerRespuestas(self, idpregunta):
        listaRespuestas = []
        try:
            self.crearConexion()
            self.cursorDict()
            self._micur.execute("select * from respuestamodelo r where r.idPregunta=%s" , (idpregunta,))
            for respuesta in self._micur:
                listaRespuestas.append(respuesta)
        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()
        if len(listaRespuestas)==0:
            listaRespuestas = None
        return listaRespuestas

    def crearExamenManual(self, listaPreguntas):
        pass
if __name__ == '__main__':
    ge = GestorExamenDAO()
    #ge.agregarPregunta("segunda pregunta",(("primera respuesta",1),("segunda respuesta",1)))
    print(ge.traerRespuestas(5))
