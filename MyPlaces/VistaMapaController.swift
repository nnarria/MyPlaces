//
//  VistaMapaController.swift
//  MyPlaces
//
//  Created by Nicolás Narria on 7/22/16.
//  Copyright © 2016 Nicolás Narria. All rights reserved.
//

import UIKit
import MapKit

protocol TransferirListPunto {
    func transferir(listPunto : [MKMapItem], indexRuta: Int)
}

class VistaMapaController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var nombrePunto: UITextField!
    
    private var puntoActual: MKMapItem!
    
    private let manejador = CLLocationManager()
    private var posicionRefencia = CLLocation()
    private var lecturaIniciada = false
    
    
    var listaPunto: [MKMapItem] = [MKMapItem]()
    var indexRuta: Int?
    
    var delegado_ : TransferirListPunto!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let allAnnotations = self.mapa.annotations
        self.mapa.removeAnnotations(allAnnotations)
        
        
        for p in self.listaPunto {
            self.anotaPunto(p)
        }
        
        print ("RUTA INDEX: \(indexRuta)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nombrePunto.delegate = self
        mapa.delegate = self
        
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        
        
        
        
        
        /*
        var puntoCoor = CLLocationCoordinate2D(latitude: 19.359727, longitude: -99.257700)
        var puntoLugar = MKPlacemark (coordinate: puntoCoor, addressDictionary: nil)
        
        origen = MKMapItem (placemark: puntoLugar)
        origen.name = "Tecnologico de Monterrey"
        
        
        puntoCoor = CLLocationCoordinate2D(latitude: 19.362896, longitude: -99.268856)
        puntoLugar = MKPlacemark (coordinate: puntoCoor, addressDictionary: nil)
        
        destino = MKMapItem(placemark: puntoLugar)
        destino.name = "Centro Comercial"
        
        puntoCoor = CLLocationCoordinate2D(latitude: 19.358543, longitude: -99.276304)
        puntoLugar = MKPlacemark (coordinate: puntoCoor, addressDictionary: nil)
        
        extra = MKMapItem(placemark: puntoLugar)
        extra.name = "Glorieta"
        
        self.anotaPunto(origen!)
        self.anotaPunto(destino!)
        self.anotaPunto(extra!)
        
        self.obtenerRuta (self.origen!, destino: self.destino!)
        self.obtenerRuta (self.destino!, destino: self.extra!)
        */
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    func anotaPunto (punto: MKMapItem) {
        let anota = MKPointAnnotation()
        anota.coordinate = punto.placemark.coordinate
        anota.title = punto.name
        
        mapa.addAnnotation(anota)
    }

    
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if (lecturaIniciada == false) {
            var region = MKCoordinateRegion()
            var location = CLLocationCoordinate2D()
            var span = MKCoordinateSpan()
            span.latitudeDelta = 0.08
            span.longitudeDelta = 0.08
            
            
            location.latitude = manejador.location!.coordinate.latitude;
            location.longitude = manejador.location!.coordinate.longitude;
            region.span = span;
            region.center = location;
            
            //inicio punto referencia
            posicionRefencia = manager.location!
            mapa.setRegion(region, animated: true)
            
            //para que te siga
            mapa.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
            lecturaIniciada = true
            
            
        }
        else {
            
            let tmp_loc = manager.location
            
            
            let puntoCoor = CLLocationCoordinate2D(latitude: (tmp_loc?.coordinate.latitude)!, longitude: (tmp_loc?.coordinate.longitude)!)
            let puntoLugar = MKPlacemark (coordinate: puntoCoor, addressDictionary: nil)
            
            puntoActual = MKMapItem(placemark: puntoLugar)
            puntoActual.name = self.nombrePunto.text!
            
            
            //agregarAlfiler(tmp_loc!)
            print ("debo agregar alfiler segun se solicite")

            //distanciaText.text = "\(round(distanciaAcumulada))" + " Mts"
        }
    }
    
    @IBAction func marcarLugar(sender: UIBarButtonItem) {
        self.listaPunto.append(puntoActual)
        
        self.anotaPunto(puntoActual!)
        
        
        //delegado_.transferir("hola desde marcarLugar: ")
        
        self.nombrePunto.text = ""
        self.nombrePunto.resignFirstResponder()
        
        delegado_.transferir(listaPunto, indexRuta: indexRuta!)
    }
    
    /*
    @IBAction func verRuta(sender: UIBarButtonItem) {
        
        if (listaPunto.count >= 2) {
            for i in 1 ..< listaPunto.count {
                self.obtenerRuta (listaPunto[i-1], destino: listaPunto[i])
            }
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
    

    @IBAction func borrarUltimoPunto(sender: UIBarButtonItem) {
        
        let allAnnotations = self.mapa.annotations
        self.mapa.removeAnnotations(allAnnotations)
        
        //mapa.annotations[mapa.annotations.endIndex]
        //mapa.removeAnnotation(mapa.annotations[mapa.annotations.endIndex])
        self.listaPunto.removeAll()
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "mostrarSoloRuta") {
            let mapSoloRuta = segue.destinationViewController as! VistaMapaRutaController
            
            mapSoloRuta.listaPunto.removeAll()
            
            for ruta in self.listaPunto {
                mapSoloRuta.listaPunto.append(ruta)
            }
        }
        
        if (segue.identifier == "irMapa") {
            print ("De regreso a menu de rutas")
        }
        
               
    }
    

}
