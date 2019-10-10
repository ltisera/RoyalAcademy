from pasajero import Pasajero
import mysql.connector
from ConexionBD import ConexionBD


class PasajeroDAO(ConexionBD):
    def __init__(self):
        pass

    def agregarPasajero(self, pasajero):
        """Agrega un usuario, validando que el mail contenga "@"
            :Parameters:
                -'pasajero': Pasajero que desea agregarse
            :Return:
                (valido, str):
                    -"valido":
                        True si se agrego a la BD
                        False si no se agrego

                    -"mensaje" :
                        un mensaje de por que no se pudo agregar
            TO-DO: -Corregir mensajes de devolucion
        """
        valido = False
        try:
            self.crearConexion()
            mailValido = False
            for i in pasajero.email:
                if(i == "@"):
                    mailValido = True
            if(mailValido is True):
                self._micur.callproc("altaPasajero", pasajero.datos())
                self._bd.commit()
                valido = True
            else:
                valido = "No lo se rick, parece falso"

        except mysql.connector.errors.IntegrityError as e:
            valido = "Usuario Usuario Duplicado" + str(e)

        finally:
            self.cerrarConexion()

        return valido

    def updatePasajero(self, pasajero):
        valido = False
        try:
            self.crearConexion()
            mailValido = False
            for i in pasajero.email:
                if(i == "@"):
                    mailValido = True
            if(mailValido is True):
                self._micur.callproc("updatePasajero", pasajero.datos())
                self._bd.commit()
                valido = True
            else:
                valido = "No lo se rick, parece falso"

        except mysql.connector.errors.IntegrityError as e:
            valido = "Usuario Usuario Duplicado" + str(e)

        finally:
            self.cerrarConexion()

        return valido

    def traerPasajero(self, DNI):
        pTraido = None
        try:
            self.crearConexion()
            self._micur.callproc("consultaPasajero", (DNI,))
            for res in self._micur.stored_results():
                r = res.fetchone()
                if(r is not None):
                    pTraido = Pasajero(registro=r)

        except mysql.connector.Error as err:
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()
        return pTraido

    def traerPasajerosXEmail(self, mail):
        try:
            self.crearConexion()
            self._micur.callproc("consultaPasajeroXEmail", (mail,))
            for result in self._micur.stored_results():
                return result.fetchone()

        except mysql.connector.Error as err:
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()

    def loginPasajero(self, dni, clave):
        try:
            self.crearConexion()
            self._micur.callproc("loginPasajero", (dni, clave))
            for result in self._micur.stored_results():
                return result.fetchone()[0] == 1

        except mysql.connector.Error as err:
            print("DANGER ALGO OCURRIO: " + str(err))
        finally:
            self.cerrarConexion()

    def loginPasajeroSinSQL(self, dni, clave):
        valido = False
        try:
            if (self.traerPasajero(dni).clave == clave):
                if (clave is not None):
                    print("Pasajero registrado")
                    valido = True
                else:
                    print("Pasajero casual")
            else:
                print("Clave incorrecta")
        except AttributeError as e:
            print("Pasajero no registrado err: " + str(e))
        return valido


if __name__ == '__main__':
    tstPDAO = PasajeroDAO()
    print(tstPDAO.loginPasajero(123, None))
    print(tstPDAO.loginPasajero(123, "ClaceFalsa"))

    print(tstPDAO.loginPasajero(1234, None))
    print(tstPDAO.loginPasajero(1234, "1234"))

    print(tstPDAO.loginPasajero(666, None))
    print(tstPDAO.loginPasajero(666, "1234"))
