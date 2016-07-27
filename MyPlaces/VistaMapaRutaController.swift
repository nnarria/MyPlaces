//
//  VistaMapaRutaController.swift
//  MyPlaces
//
//  Created by Nicolás Narria on 7/23/16.
//  Copyright © 2016 Nicolás Narria. All rights reserved.
//

import UIKit
import MapKit

class VistaMapaRutaController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    var listaPunto: [MKMapItem] = [MKMapItem]()
    
    private let manejador = CLLocationManager()
    private var posicionRefencia = CLLocation()
    private var lecturaIniciada = false

    
    override func viewWillAppear(animated: Bool) {
        
        if (listaPunto.count > 0) {
            self.anotaPunto(listaPunto[0])
        }
        
        if (listaPunto.count >= 2) {
            for i in 1 ..< listaPunto.count {
                self.anotaPunto(listaPunto[i])
                self.obtenerRuta (listaPunto[i-1], destino: listaPunto[i])
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapa.delegate = self
        manejador.delegate = self
   
    }
    
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    
    
    func obtenerRuta (origen: MKMapItem, destino: MKMapItem) {
        let solicitud =  MKDirectionsRequest()
        solicitud.source = origen
        solicitud.destination = destino
        solicitud.transportType = .Walking
        
        let indicaciones = MKDirections(request: solicitud)
        indicaciones.calculateDirectionsWithCompletionHandler({
            (respuesta: MKDirectionsResponse?, error: NSError?) in
            if error != nil {
                print ("Error al obtener la ruta")
            }
            else {
                self.muestraRuta (respuesta!)
            }
        })
        
    }
    
    func muestraRuta (respuesta: MKDirectionsResponse) {
        for ruta in respuesta.routes {
            mapa.addOverlay(ruta.polyline, level: MKOverlayLevel.AboveRoads)
            
            for paso in ruta.steps {
                print (paso.instructions)
            }
        }
        
        //let centro = origen.placemark.coordinate
        let centro = self.listaPunto[0].placemark.coordinate
        
        let region = MKCoordinateRegionMakeWithDistance(centro, 3000, 3000)
        
        mapa.setRegion(region, animated: true)
        
    }

    
    /*
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            
            mapa.mapType = MKMapType.Standard
        }
        else {
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    */


    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let alerta = UIAlertController (title: "ERROR", message: "error \(error.code)", preferredStyle:.Alert)
        let accionOk = UIAlertAction (title: "OK", style: .Default, handler:
            {accion in
                //...
        })
        
        alerta.addAction(accionOk)
        self.presentViewController(alerta, animated: true, completion: nil)
    }
    
    
    func anotaPunto (punto: MKMapItem) {
        let anota = MKPointAnnotation()
        anota.coordinate = punto.placemark.coordinate
        anota.title = punto.name
        
        mapa.addAnnotation(anota)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
