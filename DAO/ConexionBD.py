import sys
sys.path.append(r'D:\DropBox\Dropbox\FAcultad\proyecto de software\RoyalAcademy\RoyalAcademy')
sys.path.append(r'C:\Users\Camila\Documents\GitHub\odbcViajes')
sys.path.append(r'C:\Users\Enzord\GitHub\RoyalAcademy')
from DAO.CONFIGS.configs import getConfigDB

import mysql.connector
from mysql.connector import pooling
from mysql.connector import Error

class ConexionBD:
    _pbd = None

    def __init__(self):
        self._micur = None
        self._bd = None

    def crearConexion(self):
        if (ConexionBD._pbd is None):
            connectionDict = getConfigDB()
            ConexionBD._pbd = mysql.connector.pooling.MySQLConnectionPool(**connectionDict)
        self._bd = self._pbd.get_connection()
        self._micur = self._bd.cursor()
    
    def cursorDict(self):
        self._micur = self._bd.cursor(dictionary=True, buffered=True)

    def cerrarConexion(self):
        self._micur.close()
        self._bd.close()

    #def cerrarCursor(self):
    #    self._micur.close()

if __name__ == '__main__':
    a = ConexionBD()
    b = ConexionBD()

    