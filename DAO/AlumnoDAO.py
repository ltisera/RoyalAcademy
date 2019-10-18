import mysql.connector
from DAO.ConexionBD import ConexionBD

class AlumnoDAO(ConexionBD):
    def __int__(self):
        pass
    


    def traerExamenesDisponibles(self, idUsuario, idCarrera):
        try:
            self.crearConexion()
            self.cursorDict()
            self._micur.execute("SELECT * FROM examen INNER JOIN carrera ON examen.idCarrera = carrera.idCarrera INNER JOIN usuario ON carrera.idCarrera = usuario.idCarrera WHERE examen.disponible = 1 and usuario.idUsuario = %s and usuario.idCarrera = %s", (idUsuario, idCarrera))
            examenes = self._micur.fetchall()

        except mysql.connector.errors.IntegrityError as err:
            print("Error: " + str(err))

        finally:
            self.cerrarConexion()
        
        return examenes

    def inscripcionAExamen(self, idExamen, idUsuario):
        mensaje="Ya estas inscripto."
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
            self._micur.execute("SELECT * FROM examen e INNER JOIN inscripcion i ON e.idExamen = i.idExamen INNER JOIN Usuario WHERE examen.disponible = 1 and inscripcion.idUsuario = %s and inscripcion.idExamen = examen.idExamen and inscripcion.examenRealizado = %s", (idUsuario, 0))
            examenes = self._micur.fetchall()

        except mysql.connector.errors.IntegrityError as err:
            print("Error: " + str(err))

        finally:
            self.cerrarConexion()

        return examenes



    def rendirExamen(self, idExamen):
        try:
            self.crearConexion()
            self._micur.execute("SELECT * FROM examen e INNER JOIN preguntasporexamen pe ON e.idExamen = pe.idExamen INNER JOIN pregunta p ON p.idPregunta = pe.idPregunta INNER JOIN respuestamodelo rm ON p.idPregunta = rm.idPregunta WHERE e.idExamen = %s", (idExamen,))
            examen = self._micur.fetchone()
            

        except mysql.connector.errors.IntegrityError as err:
            print("Error: " + str(err))

        finally:
            self.cerrarConexion()
        
        return examen
    


    def responderPregunta(self, idUsuario, idRespuesta, idExamen):
        try:
            self.crearConexion()
            self._micur.execute("INSERT INTO respuestaAlumno(idUsuario, idRespuesta, idExamen) values (%s, %s, %s)", (idUsuario, idRespuesta, idExamen))
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

        