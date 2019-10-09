class Pasajero():
    
    def __init__(self, DNI=0, nombre="", apellido="",telefono="",email="",millas=0,clave="",direccion="",nacionalidad="", registro = None):
        if(not(registro is None)):
            self._DNI = registro[0]
            self._nombre = registro[1]
            self._apellido = registro[2]
            self._telefono = registro[3]
            self._email = registro[4]
            self._millas = registro[5]
            self._clave = registro[6]
            self._direccion = registro[7]
            self._nacionalidad = registro[8]
        else:
            self._DNI = DNI
            self._nombre = nombre
            self._apellido = apellido
            self._telefono = telefono
            self._email = email
            self._millas = millas
            self._clave = clave
            self._direccion = direccion
            self._nacionalidad = nacionalidad

    @property
    def DNI(self):
    	return self._DNI
    
    @DNI.setter
    def DNI(self, DNI):
    	self._DNI = DNI


    @property
    def nombre(self):
    	return self._nombre
    
    @nombre.setter
    def nombre(self, nombre):
    	self._nombre = nombre


    @property
    def apellido(self):
    	return self._apellido
    
    @apellido.setter
    def apellido(self, apellido):
    	self._apellido = apellido

    @property
    def telefono(self):
    	return self._telefono
    
    @telefono.setter
    def telefono(self, telefono):
    	self._telefono = telefono

    @property
    def email(self):
    	return self._email
    
    @email.setter
    def email(self, email):
    	self._email = email


    @property
    def millas(self):
    	return self._millas
    
    @millas.setter
    def millas(self, millas):
    	self._millas = millas

    @property
    def clave(self):
    	return self._clave
    
    @clave.setter
    def clave(self, clave):
    	self._clave = clave

    @property
    def direccion(self):
    	return self._direccion
    
    @direccion.setter
    def direccion(self, direccion):
    	self._direccion = direccion

    @property
    def nacionalidad(self):
    	return self._nacionalidad
    
    @nacionalidad.setter
    def nacionalidad(self, nacionalidad):
    	self._nacionalidad = nacionalidad

    def datos(self):
        return (self._DNI,
            self._nombre,
            self._apellido,
            self._telefono,
            self._email,
            self._millas,
            self._clave,
            self._direccion,
            self._nacionalidad)
    def __str__(self):
        
        return str(self.__dict__)

if __name__ == '__main__':
    print("Estoy en el main de pasajero")
    print("Armando usuario")
    usrTST = Pasajero()
    print(usrTST)
