class Usuario():
    def __init__(self, idUsuario=None, email="", password="", tipoUsuario="", idCarrera=""):
        self._idUsuario = idUsuario
        self._email = email
        self._password = password
        self._tipoUsuario = tipoUsuario
        self._idCarrera = idCarrera
        

    @property
    def idUsuario(self):
        return self._idUsuario

    @idUsuario.setter
    def idUsuario(self, id):
        self._idUsuario = id

    @property
    def email(self):
        return self._email

    @email.setter
    def email(self, email):
        self._email = str(email)

    @property
    def password(self):
        return self._password

    @password.setter
    def password(self, password):
        self._password = str(password)

   	@property
    def tipoUsuario(self):
        return self._tipoUsuario

    @tipoUsuario.setter
    def tipoUsuario(self, tipoUsuario):
        self._tipoUsuario = tipoUsuario

    @property
    def idCarrera(self):
        return self._idCarrera

    @idCarrera.setter
    def idCarrera(self, idCarrera):
        self._idCarrera = idCarrera


    def __str__(self):
        return str("id: " + str(self.idUsuario)
                   + " Email: " +
                   str(self.email) + " Password: " +
                   str(self.password) + " tipoUsuario: " +
                   str(self._tipoUsuario) + " idCarrera: " +
                   str(self._idCarrera))