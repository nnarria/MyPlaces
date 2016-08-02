//
//  Punto.swift
//  MyPlaces
//
//  Created by Nicolás Narria on 7/20/16.
//  Copyright © 2016 Nicolás Narria. All rights reserved.
//

import Foundation

class Punto {
    var longitud: Double
    var latitud: Double
    var nombre: String
    
    init (longitud: Double, latitud: Double, nombre: String) {
        self.longitud = longitud
        self.latitud = latitud
        self.nombre = nombre
    }
    
    
}
