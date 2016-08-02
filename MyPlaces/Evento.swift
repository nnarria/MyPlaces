//
//  Evento.swift
//  MyPlaces
//
//  Created by Nicolás Narria on 8/1/16.
//  Copyright © 2016 Nicolás Narria. All rights reserved.
//

import Foundation

class Evento {
    var feria: String = ""
    var fecha: String = ""
    var sector: String = ""
    var ciudadPais: String = ""
    var tipo: String = ""
    
    init (feria: String, fecha: String, ciudadPais: String, sector: String, tipo: String) {
        self.feria = feria
        self.fecha = fecha
        self.ciudadPais = ciudadPais
        self.sector = sector
        self.tipo = tipo
    }
    
    init () {
        self.feria = "";
        self.fecha = "";
        self.ciudadPais = "";
        self.sector = "";
        self.tipo = "";
    }
}
