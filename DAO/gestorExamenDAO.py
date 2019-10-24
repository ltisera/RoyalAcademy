import mysql.connector
import sys
sys.path.append(r'C:\Users\Enzord\GitHub\RoyalAcademy')
import random

from DAO.ConexionBD import ConexionBD

class GestorExamenDAO(ConexionBD):
    def __init__(self):
        pass

    def traerMaterias(self, idCarrera):
        listaMaterias = []
        try:
            self.crearConexion()
            self.cursorDict()
            self._micur.execute("select * from materia m where m.idCarrera=%s" , (idCarrera,))
            for materia in self._micur:
                listaMaterias.append(materia)
        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()
        if len(listaMaterias)==0:
            listaMaterias = None
        return listaMaterias

    def traerCarreras(self):
        listaCarreras = []
        try:
            self.crearConexion()
            self.cursorDict()
            self._micur.execute("select * from carrera")
            for carrera in self._micur:
                listaCarreras.append(carrera)
        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()
        if len(listaCarreras)==0:
            listaCarreras = None
        return listaCarreras
    """
    entradas:
        -descripcion: descripcion de la pregunta
        -materia: nombre de la materia
        -respuestas(tupla): (descripcion,esCorrecto)
            -descripcion: lo que dice la respuesta
            -esCorrecto: si la respuesta es correcta, valores 0 o 1


    ejemplo:
        agregarPregunta("De que color es el gato",(("blanco",0),("negro",1),("soy Daltonico",0)))
        {{"De que color es el gato"},{{"blanco",0},{"negro",1},{"soy Daltonico",0}}}

    """
    def agregarPregunta(self, descripcion, idMateria, respuestas):
        idpregunta = 0
        try:
            self.crearConexion()
            self._micur.execute("insert into pregunta(descripcion,idMateria) values (%s,%s)",(descripcion,idMateria))
            idpregunta = self._micur.lastrowid
            queryRespuestas="insert into respuestamodelo(idpregunta,descripcion,esCorrecta) values (%s,%s,b'%s')"
            for resp in respuestas:
                self._micur.execute(queryRespuestas,(idpregunta,resp[0],resp[1]))
            self._bd.commit()

        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))

        finally:
            self.cerrarConexion()
        return idpregunta

    """Trae las preguntas de la materia pero sin las respuestas(Lista de dict)"""

    def traerPreguntas(self, idMateria):
        listaPreguntas = []
        try:
            self.crearConexion()
            self.cursorDict()
            self._micur.execute("select * from pregunta p where p.idMateria = %s",(idMateria,))
            for pregunta in self._micur:
                listaPreguntas.append(pregunta)
        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()
        if len(listaPreguntas)==0:
            listaPreguntas = None
        return listaPreguntas
      
    """ Trae las respuestas de una pregunta (Lista de dict)"""
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

    """ Trae las preguntas como el metodo traerPreguntas() pero
        para cada pregunta se le agrega el atributo al dict "respuestas" que
        contiene la lista de respuestas como lo trae traerRespuestas() """
    def traerPreguntasConRespuestas(self, idMateria): #Filtrar por Materia Tambien??
        listaPreguntas = self.traerPreguntas(idMateria)
        if listaPreguntas!=None:
            for pregunta in listaPreguntas:
                pregunta["respuestas"] = self.traerRespuestas(pregunta["idPregunta"])
        return listaPreguntas

    """ EJEMPLO:
            crearExamenManual('2019-09-20 20:00:00', 5, 1, "historia",(5,2,4,7,14,54)) 
    NO TESTEADO!!!!!!!
    """
    def crearExamenManual(self, fecha, disponible, idMateria, listaIdPreguntas): #es necesario mas parametros??
        try:
            self.crearConexion()
            self._micur.execute("insert into examen(fecha,disponible,idMateria) values (%s,b'%s',%s)",(fecha,disponible,idMateria))
            idExamen = self._micur.lastrowid
            queryPreguntas="insert into preguntasporexamen(idPregunta,idExamen) values (%s,%s)"
            for idPregunta in listaIdPreguntas:
                self._micur.execute(queryPreguntas,(idPregunta,idExamen))
            self._bd.commit()

        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))

        finally:
            self.cerrarConexion()
    
    def crearExamenAutomatico(self, fecha, idMateria, disponible = 1):
        idExamen = 0
        try:
            self.crearConexion()
            self._micur.execute("insert into examen(fecha,disponible,idMateria) values (%s,b'%s',%s)",(fecha,disponible,idMateria))
            idExamen = self._micur.lastrowid
            queryPreguntas="insert into preguntasporexamen(idPregunta,idExamen) values (%s,%s)"
            self._micur.execute("select idPregunta from pregunta p where p.idMateria = %s",(idMateria,)) #filtrar por idMateria
            preguntas = self._micur.fetchall()
            pregunta = None
            for i in range(50):
                pregunta = random.choice(preguntas)
                self._micur.execute(queryPreguntas,(pregunta[0],idExamen))
                preguntas.remove(pregunta)
            self._bd.commit()

        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))
            idExamen = 0
            self._bd.rollback()

        except IndexError as err:
            print("No hay suficientes preguntas para el examen")
            idExamen = 0
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()
        return idExamen

    def traerExamenes(self, idMateria):
        listaExamenes = []
        try:
            self.crearConexion()
            self.cursorDict()
            self._micur.execute("select * from examen e where e.idMateria = %s",(idMateria,))
            for examen in self._micur:
                listaExamenes.append(examen)
        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()
        if len(listaExamenes)==0:
            listaExamenes = None
        return listaExamenes

    def traerExamenCompleto(self, idExamen):
        examen = None
        try:
            self.crearConexion()
            self.cursorDict()
            self._micur.execute("select * from examen e where e.idExamen = %s",(idExamen,))
            examen = self._micur.fetchone()
            examen["listaPreguntas"]=[]
            self._micur.execute("select p.* from preguntasporexamen pxe inner join pregunta p on p.idPregunta = pxe.idPregunta where pxe.idExamen = %s",(examen["idExamen"],))
            for pregunta in self._micur:
                examen["listaPreguntas"].append(pregunta)
            for pregunta in examen["listaPreguntas"]:
                pregunta["listaRespuestas"]=[]
                self._micur.execute("select * from respuestamodelo r where r.idPregunta=%s" , (pregunta["idPregunta"],))

        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()
        return examen
        
    """ Finaliza el examen seteando a todos los examenes Realizados """
    def finalizarExamen(self,idExamen):
        try:
            self.crearConexion()
            self._micur.execute("update inscripcion set examenRealizado = b'1' where idExamen = %s",(idExamen,))
            self._bd.commit()

        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))

        finally:
            self.cerrarConexion()

    def crearPlanillaNotas(self, idExamen):
        try:
            self.crearConexion()
            self.cursorDict()
            print("probandooo" , idExamen)
            modeloExamen = self.traerExamenCompleto(idExamen)
            self._micur.execute("select i.idUsuario from inscripcion where i.idExamen=%s",(idExamen,))
        

        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))

        finally:
            self.cerrarConexion()



if __name__ == '__main__':
    ge = GestorExamenDAO()
    idcarrera = 2
    idmateria = 1
    idexamen = 15
    fecha = '2019-10-10 20:00:00'
    cantidadPreguntasACrear = 70
    #ge.agregarPregunta("segunda pregunta","matematica",(("primera respuesta",1),("segunda respuesta",1)))
    #print(ge.traerPreguntasConRespuestas(idmateria))
    #ge.crearExamenAutomatico(fecha, materia, 1)
    
    #print(ge.traerMaterias(idcarrera))

    ########Agregar Preguntas Para Testeo
    #for x in range(cantidadPreguntasACrear):
    #    ge.agregarPregunta("pregunta"+str(x),idmateria,(("p"+str(x)+"resp1",0),("p"+str(x)+"resp2",1),("p"+str(x)+"resp3",0)))
    ########

    #######Traer Examenes De Una idMateria
    #print(ge.traerExamenes(idmateria))

    ####### Traer Examen Completo
    #print(ge.traerExamenCompleto(idexamen))

    ####### Finalizar Examen
    #ge.finalizarExamen(idexamen)

    ####### Crear Planilla Notas
    ge.crearPlanillaNotas(idexamen)