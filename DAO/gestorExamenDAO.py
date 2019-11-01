import mysql.connector
import sys
sys.path.append(r'C:\Users\Enzord\GitHub\RoyalAcademy')
import random

from DAO.ConexionBD import ConexionBD
from DAO.AlumnoDAO import AlumnoDAO


class GestorExamenDAO(ConexionBD):
    def __init__(self):
        pass

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
        -idCarrera: id de la Carrera
        -respuestas(tupla): (descripcion,esCorrecto)
            -descripcion: lo que dice la respuesta
            -esCorrecto: si la respuesta es correcta, valores 0 o 1


    ejemplo:
        agregarPregunta("De que color es el gato",1,(("blanco",0),("negro",1),("soy Daltonico",0)))
        {{"De que color es el gato"},{{"blanco",0},{"negro",1},{"soy Daltonico",0}}}

    """
    def agregarPregunta(self, descripcion, idCarrera, respuestas):
        idpregunta = 0
        try:
            self.crearConexion()
            self._micur.execute("insert into pregunta(descripcion,idCarrera) values (%s,%s)",(descripcion,idCarrera))
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

    """Trae las preguntas de la Carrera pero sin las respuestas(Lista de dict)"""

    def traerPreguntas(self, idCarrera):
        listaPreguntas = []
        try:
            self.crearConexion()
            self.cursorDict()
            self._micur.execute("select * from pregunta p where p.idCarrera = %s",(idCarrera,))
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
    def traerPreguntasConRespuestas(self, idCarrera): 
        listaPreguntas = self.traerPreguntas(idCarrera)
        if listaPreguntas!=None:
            for pregunta in listaPreguntas:
                pregunta["respuestas"] = self.traerRespuestas(pregunta["idPregunta"])
        return listaPreguntas


    """ Metodo: crearExamenManual
        Retorno: 
            TRUE si se cargo en la BD
            FALSE si no se cargo en la BD
        EJEMPLO:
            crearExamenManual('2019-09-20 20:00:00', 5, 1, "historia",(5,2,4,7,14,54)) 
    TESTEADO!!!!!!!
    """
    def crearExamenManual(self, fecha, disponible, idCarrera, listaIdPreguntas): #es necesario mas parametros??
        resultado = False
        try:
            self.crearConexion()
            self._micur.execute("insert into examen(fecha,disponible,idCarrera) values (%s,b'%s',%s)",(fecha,disponible,idCarrera))
            idExamen = self._micur.lastrowid
            queryPreguntas="insert into preguntasporexamen(idPregunta,idExamen) values (%s,%s)"
            for idPregunta in listaIdPreguntas:
                self._micur.execute(queryPreguntas,(idPregunta,idExamen))
            self._bd.commit()
            resultado = True

        except mysql.connector.errors.IntegrityError as err:

            print("DANGER ALGO OCURRIO: " + str(err))
            self._bd.rollback()
            print("Tiro rollback")
            resultado = False
        
        finally:
            self.cerrarConexion()
            return resultado
    
    def crearExamenAutomatico(self, fecha, idCarrera, disponible = 1):
        idExamen = 0
        try:
            self.crearConexion()
            self._micur.execute("insert into examen(fecha,disponible,idCarrera) values (%s,b'%s',%s)",(fecha,disponible,idCarrera))
            idExamen = self._micur.lastrowid
            queryPreguntas="insert into preguntasporexamen(idPregunta,idExamen) values (%s,%s)"
            self._micur.execute("select idPregunta from pregunta p where p.idCarrera = %s",(idCarrera,)) #filtrar por idCarrera
            preguntas = self._micur.fetchall()
            pregunta = None
            for i in range(50):
                i = i
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

    def traerExamenes(self, idCarrera):
        listaExamenes = []
        try:
            self.crearConexion()
            self.cursorDict()
            self._micur.execute("select * from examen e where e.idCarrera = %s",(idCarrera,))
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
                self._micur.execute("select * from respuestamodelo r where r.idPregunta=%s" , (pregunta["idPregunta"],))
                pregunta["listaRespuestas"]= self._micur.fetchall()

        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))
            examen = None
        except:
            print("UN ERROR HA OCURRIDO FUERA DE LA BD")
            examen = None
        finally:
            self.cerrarConexion()
        return examen
        
    """ Finaliza el examen seteando REALIZADO a todos los examenes """
    def finalizarExamen(self,idExamen):
        try:
            self.crearConexion()
            self._micur.execute("update inscripcion set examenRealizado = b'1' where idExamen = %s",(idExamen,))
            self._bd.commit()

        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))

        finally:
            self.cerrarConexion()


    """ Inserta el examen con las notas de cada alumno en la planilla, solo debe utilizarse despues de finalizarExamen()"""
    def crearPlanillaNotas(self, idExamen):
        resultado = False
        try:
            modeloExamen = self.traerExamenCompleto(idExamen)
            self.crearConexion()
            self.cursorDict()
            self._micur.execute("select i.idUsuario from inscripcion i where i.idExamen = %s",(idExamen,))
            listaUsuarios = self._micur.fetchall()
            NotaUsuario = 0
            for usuario in listaUsuarios:
                NotaUsuario = 0
                self._micur.execute("select ra.idRespuesta from respuestaalumno ra where ra.idExamen = %s and ra.idUsuario = %s",(idExamen,usuario["idUsuario"]))
                usuario["respuestas"]=[]
                for respuesta in self._micur:
                    usuario["respuestas"].append(respuesta["idRespuesta"])
                for pregunta in modeloExamen["listaPreguntas"]:
                    preguntaBien = 1
                    for respuesta in pregunta["listaRespuestas"]:
                        if (usuario["respuestas"].count(respuesta["idRespuesta"])+respuesta["esCorrecta"])==1:
                            preguntaBien = 0
                    NotaUsuario = NotaUsuario + preguntaBien
                self._micur.execute("insert into planillanotas (idUsuario,idExamen,notaExamen) values (%s,%s,%s)",(usuario["idUsuario"],idExamen,NotaUsuario))
            self._bd.commit()
            resultado = True
        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))

        finally:
            self.cerrarConexion()
            return resultado
    #SELECT * FROM royalacademydb.planillanotas as pn inner join royalacademydb.examen as e where e.idExamen = pn.idExamen and e.idCarrera = 1;
    def traerAlumosDeExamenConNota(self, idExamen):
        planilla = []
        try:
            self.crearConexion()
            self.cursorDict()
            self._micur.execute("SELECT * FROM royalacademydb.planillanotas as pn inner join royalacademydb.examen as e where e.idExamen = pn.idExamen and pn.notaPractico is NULL and e.idExamen = %s;",(idExamen,))
            for registro in self._micur:
                planilla.append(registro)
        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()
        if len(planilla)==0:
            planilla = None
        return planilla

    """ Planilla de notas de los usuarios de un examen """
    def traerPlanillaDelExamen(self, idExamen):
        planilla = []
        try:
            self.crearConexion()
            self.cursorDict()
            self._micur.execute("select * from planillanotas p where p.idExamen = %s",(idExamen,))
            for registro in self._micur:
                planilla.append(registro)
        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()
        if len(planilla)==0:
            planilla = None
        return planilla

    """
    Ingresar nota practica de solo un alumno
    """
    def ingresarNotaPracticaDeAlumno(self,idExamen,idUsuario,notaPractico):
        resultado = False
        try:
            self.crearConexion()
            self._micur.execute("update planillanotas set notaPractico = %s where idExamen = %s and idUsuario = %s",(notaPractico,idExamen,idUsuario))
            self._bd.commit()
            resultado = True
        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()
            return resultado
    
    """
    Ingresar notas practicas de varios alumnos a la vez

    -listaNotas: [(idUsuario,Nota),(idUsuario,Nota),etc]
        ejemplo: [(2,9),(3,10),etc] 
    """
    def ingresarNotasPracticas(self,idExamen,listaNotas):
        resultado = False
        try:
            self.crearConexion()
            query = "update planillanotas set notaPractico = %s where idExamen = %s and idUsuario = %s"
            for nota in listaNotas:
                self._micur.execute(query,(nota[1],idExamen,nota[0]))
            self._bd.commit()
            resultado = True
        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()
            return resultado

    """ Nota de aprobacion del examen """
    def ingresarNotaDeAprobacion(self, idExamen, nota):
        resultado = False
        try:
            self.crearConexion()
            self._micur.execute("update examen set notaAprobacion = %s where idExamen = %s",(nota,idExamen))
            self._bd.commit()
            resultado = True
        except mysql.connector.errors.IntegrityError as err:
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()
            return resultado

if __name__ == '__main__':
    ge = GestorExamenDAO()
    idcarrera = 2
    idmateria = 1
    idexamen = 6
    idusuario = 5
    fecha = '2019-10-10 20:00:00'
    cantidadPreguntasACrear = 70
    #ge.agregarPregunta("segunda pregunta","matematica",(("primera respuesta",1),("segunda respuesta",1)))
    #print(ge.traerPreguntasConRespuestas(idmateria))
    #ge.crearExamenAutomatico(fecha, materia, 1)
    
    #print(ge.traerMaterias(idcarrera))

    ########Agregar Preguntas Para Testeo
    #for x in range(cantidadPreguntasACrear):
    #    ge.agregarPregunta("pregunta"+str(x),idcarrera,(("p"+str(x)+"resp1",0),("p"+str(x)+"resp2",1),("p"+str(x)+"resp3",0)))
    ########

    #######Traer Examenes De Una idMateria
    #print(ge.traerExamenes(idmateria))

    ####### Traer Examen Completo
    #print(ge.traerExamenCompleto(idexamen))

    ####### Finalizar Examen
    #ge.finalizarExamen(idexamen)

    ####### Crear respuestas de alumnos para testeo
    #examen = ge.traerExamenCompleto(idexamen)
    #alumnodao = AlumnoDAO()
    #for pregunta in examen["listaPreguntas"]:
    #    alumnodao.responderPregunta(idusuario,(random.choice(pregunta["listaRespuestas"])["idRespuesta"],),idexamen)

    ####### Crear Planilla Notas
    #ge.crearPlanillaNotas(idexamen)

    ####### Traer Planilla Notas
    #print(ge.traerPlanillaDelExamen(idexamen))

    ####### Ingresar Nota Practico
    #ge.ingresarNotaPracticaDeAlumno(idexamen,3,9)

    ####### Ingresar Notas Prácticas
    #ge.ingresarNotasPracticas(idexamen,[(3,7),(4,5),(5,10)])

    ####### Ingresar Nota de Aprobacion
    #ge.ingresarNotaDeAprobacion(idexamen, 40)