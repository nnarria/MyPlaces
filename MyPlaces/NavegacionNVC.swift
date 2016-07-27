//
//  NavegacionNVC.swift
//  MyPlaces
//
//  Created by Nicolás Narria on 7/20/16.
//  Copyright © 2016 Nicolás Narria. All rights reserved.
//

import UIKit

class NavegacionNVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        /*
        
        if (segue.identifier == "toListRuta") {
            (segue.destinationViewController as! ListRuta).count = (sender as! MenuPrincipalVC).count
            (segue.destinationViewController as! ListRuta).msg = (sender as! MenuPrincipalVC).msg + (String)((sender as! MenuPrincipalVC).count)
            
        }
        
        if (segue.identifier == "segueNuevaRuta") {

        }
        */
        
        if (segue.identifier == "detalle") {
            print ("debo ir a el resultado del qr")
            let origen = sender as? VistaCamaraQRController
            let vQR = segue.destinationViewController as! VistaQRController
            vQR.urls = origen!.urls
            
            origen!.sesion?.stopRunning()
        }
 
        
    }
    

}
