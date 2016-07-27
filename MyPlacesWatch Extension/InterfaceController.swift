//
//  InterfaceController.swift
//  MyPlacesWatch Extension
//
//  Created by Nicolás Narria on 7/23/16.
//  Copyright © 2016 Nicolás Narria. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var mapa: WKInterfaceMap!
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        let tec = CLLocationCoordinate2D(latitude: 19.283996,longitude: -99.136006)
        let region = MKCoordinateRegion(center: tec, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
        self.mapa.setRegion(region)
        self.mapa.addAnnotation(tec, withPinColor: .Purple)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func hacerZoom(value: Float) {
        let grados:CLLocationDegrees = CLLocationDegrees (value)/10
        let ventana = MKCoordinateSpanMake(grados, grados)
        
        let tec = CLLocationCoordinate2D(latitude: 19.283996,longitude: -99.136006)
        let region = MKCoordinateRegionMake(tec, ventana)
        
        mapa.setRegion(region)
    }
}
