//
//  Ruta.swift
//  MyPlaces
//
//  Created by Nicolás Narria on 7/22/16.
//  Copyright © 2016 Nicolás Narria. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Ruta {
    var puntos: [MKMapItem] = [MKMapItem]()
    var nombre: String = ""
    var descripcion: String = ""
    var imagen: UIImage!
    
    init (puntos: [MKMapItem], nombre: String, descripcion: String, imagen: UIImage?) {
        self.puntos = puntos
        self.nombre = nombre
        self.descripcion = descripcion
        self.imagen = imagen
    }
    
}