import mysql.connector
from DAO.ConexionBD import ConexionBD

class AlumnoDAO(ConexionBD):
    def __int__(self):
        pass
    


    def traerExamenesDisponibles(self, idUsuario, idCarrera):
        try:
            lstExamenes = []
            self.crearConexion()
            self.cursorDict()
            self._micur.execute("SELECT * FROM examen INNER JOIN carrera ON examen.idCarrera = carrera.idCarrera INNER JOIN usuario ON carrera.idCarrera = usuario.idCarrera WHERE examen.disponible = 1 and usuario.idUsuario = %s and usuario.idCarrera = %s", (idUsuario, idCarrera))
            examenesDisponibles = self._micur.fetchall()
            
            for examen in examenesDisponibles:
                self._micur.execute("SELECT * FROM inscripcion WHERE inscripcion.idUsuario =%s and inscripcion.idExamen =%s", (idUsuario, examen['idExamen']))
                inscripcion = self._micur.fetchone()
                
                if inscripcion == None:
                    lstExamenes.append(examen)

        except mysql.connector.errors.IntegrityError as err:
            print("Error: " + str(err))

        finally:
            self.cerrarConexion()
        
        return lstExamenes

    def inscripcionAExamen(self, idExamen, idUsuario):
        mensaje="Ya estabas inscripto."
        try:
            self.crearConexion()
            self._micur.execute("SELECT * FROM inscripcion where idUsuario = %s and idExamen = %s", (idUsuario, idExamen))
            inscripcion = self._micur.fetchone()
            if inscripcion == None:
                self._micur.execute("INSERT INTO inscripcion(idUsuario, idExamen, examenRealizado) values (%s, %s, %s)", (idUsuario, idExamen, 0))
                self._bd.commit()
                mensaje = "Inscripcion realizada."
                self._micur.execute("SELECT * FROM inscripcion where idUsuario = %s and idExamen = %s", (idUsuario, idExamen))
                inscripcion = self._micur.fetchone()
                

        except mysql.connector.errors.IntegrityError as err:
            print("Error: " + str(err))

        finally:
            self.cerrarConexion()
        
        return (inscripcion, mensaje)
    


    def traerExamenesARendir(self, idUsuario):
        #Aca se supone que traeria los examenes completos, con las preguntas y todo, pero el sql me daba error 
        # asi que trae la lista de examenes a rendir incompletos, y cuando quiera rendir uno trae ese en especifico con las preguntas, respuestas, imagenes etc, con rendirExamen()
        try:
            self.crearConexion()
            self.cursorDict()
            self._micur.execute("SELECT * FROM examen e INNER JOIN inscripcion i ON e.idExamen = i.idExamen WHERE e.disponible = 1 and i.idUsuario = %s and i.examenRealizado = 0", (idUsuario,))
            examenes = self._micur.fetchall()

        except mysql.connector.errors.IntegrityError as err:
            print("Error: " + str(err))

        finally:
            self.cerrarConexion()

        return examenes



    def rendirExamen(self, idExamen):
        try:
            self.crearConexion()
            self.cursorDict()
            #self._micur.execute("SELECT * FROM examen INNER JOIN preguntasporexamen ON examen.idExamen = preguntasporexamen.idExamen INNER JOIN pregunta ON pregunta.idPregunta = preguntasporexamen.idPregunta INNER JOIN respuestamodelo ON pregunta.idPregunta = respuestamodelo.idPregunta WHERE examen.idExamen = %s", (idExamen,))
            self._micur.execute("SELECT * FROM pregunta INNER JOIN preguntasporexamen ON pregunta.idPregunta = preguntasporexamen.idPregunta WHERE preguntasporexamen.idExamen = %s", (idExamen,))
            preguntas = self._micur.fetchall()
            for pregunta in preguntas:
                self._micur.execute("SELECT * FROM respuestamodelo where idPregunta = %s",(pregunta["idPregunta"],))
                pregunta['respuestas'] = self._micur.fetchall()
            
            self._micur.execute("select count(distinct idPregunta) as progreso from respuestamodelo inner join respuestaalumno on respuestaalumno.idRespuesta = respuestamodelo.idRespuesta where respuestaalumno.idExamen = %s ",(idExamen,))
            progreso = self._micur.fetchone()

        except mysql.connector.errors.IntegrityError as err:
            print("Error: " + str(err))

        finally:
            self.cerrarConexion()
        
        return preguntas, progreso
    


    def responderPregunta(self, idUsuario, respuestas, idExamen):
        try:
            self.crearConexion()
            for respuesta in respuestas:
                self._micur.execute("INSERT INTO respuestaAlumno(idUsuario, idRespuesta, idExamen) values (%s, %s, %s)", (idUsuario, respuesta, idExamen))
            
            self._bd.commit()

        except mysql.connector.errors.IntegrityError as err:
            print("Error: " + str(err))

        finally:
            self.cerrarConexion()



    def finalizarExamen(self, idUsuario, idExamen):
        try:
            self.crearConexion()
            self._micur.execute("UPDATE inscripcion SET examenRealizado = 1 WHERE idUsuario = %s and idExamen = %s",(idUsuario, idExamen))
            self._bd.commit()

        except mysql.connector.errors.IntegrityError as err:
            print("Error: " + str(err))

        finally:
            self.cerrarConexion()

if __name__ == '__main__':
    alumnoDao = AlumnoDAO()
    #print("TEST INSCRIPCIONNNNNNNNNNNNNNNNNNN")
    #print(alumnoDao.inscripcionAExamen(2,1))

    #print("EXAMENES A RENDIR")
    #print(alumnoDao.traerExamenesARendir(2))

    #print("Responder pregunta")
    #alumnoDao.responderPregunta(1,2,1)
    #alumnoDao.responderPregunta(1,3,1)

    #print("FINALIZAR EXAMEN")
    #alumnoDao.finalizarExamen(1,2)

    print("RENDIR EXAMEN")
    print(alumnoDao.rendirExamen('1'))

        