
#modo = 'produccion'
modo = 'desarrollo'


def getConfigDB():
    configDB = {}
    if (modo == 'desarrollo'):
        configDB['host'] = 'localhost'
        configDB['user'] = 'adminODBC'
        configDB['password'] = '1234'
        configDB['database'] = 'odbcViajes'
        configDB['auth_plugin']='mysql_native_password'

    return configDB