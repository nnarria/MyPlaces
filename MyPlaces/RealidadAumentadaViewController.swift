//
//  RealidadAumentadaViewController.swift
//  MyPlaces
//
//  Created by Nicolás Narria on 7/27/16.
//  Copyright © 2016 Nicolás Narria. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class RealidadAumentadaViewController: UIViewController, ARDataSource {
    var puntos:[MKMapItem] = []
    var nombreRuta: String = ""
    
    var latitudActual: Double?
    var longitudActual: Double?
    let delta = 0.05
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let llat = self.puntos[0].placemark.coordinate.latitude
        let llon = self.puntos[0].placemark.coordinate.longitude
        
        print("AR primer Punto: \(llat), \(llon)")
        
        
        
        iniciaRAG()

        // Do any additional setup after loading the view.
    }
    


    func ar(arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let vista = TestAnnotationView()
        vista.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        vista.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
        return vista
    }
    
    func iniciaRAG() {
        
        let puntosDeInteres = obtenerAnotaciones(latitudActual!, longitud: longitudActual!, delta: delta)
        
        let arViewController = ARViewController()
        arViewController.debugEnabled = true
        arViewController.dataSource = self
        arViewController.maxDistance = 0
        arViewController.maxVisibleAnnotations = 100
        arViewController.maxVerticalLevel = 5
        arViewController.headingSmoothingFactor = 0.05
        arViewController.trackingManager.userDistanceFilter = 25
        arViewController.trackingManager.reloadDistanceFilter = 75
        
        //arViewController.
        
        arViewController.setAnnotations(puntosDeInteres)
        self.presentViewController(arViewController, animated: true, completion: nil)
        
    }
    
    
    
    private func obtenerAnotaciones (latitud: Double, longitud: Double, delta: Double) -> Array<ARAnnotation> {
        var anotaciones: [ARAnnotation] = []
        
        srand48(3)
        
        for p in self.puntos {
            let anotacion = ARAnnotation()
            let locTmp = CLLocation (latitude: p.placemark.coordinate.latitude, longitude: p.placemark.coordinate.longitude)
            anotacion.location = locTmp
            anotacion.title = p.name
            anotaciones.append(anotacion)
        }
        
        
        return anotaciones
        
    }
    
    /*
    private func obtenerPosiciones (latitud: Double, longitud: Double, delta: Double) -> CLLocation {
        var lat = latitud
        var lon = longitud
        
        let latDelta = -(delta)/2 + drand48()*delta
        let lonDelta = -(delta)/2 + drand48()*delta
        lat = lat + latDelta
        lon = lon + lonDelta
        
        return CLLocation(latitude: lat, longitude: lon)
    }
    */

}
