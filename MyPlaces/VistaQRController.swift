//
//  VistaQRController.swift
//  MyPlaces
//
//  Created by Nicolás Narria on 7/23/16.
//  Copyright © 2016 Nicolás Narria. All rights reserved.
//

import UIKit

class VistaQRController: UIViewController {

    @IBOutlet weak var browserQR: UIWebView!
    @IBOutlet weak var textDirQR: UITextField!
    
    var urls: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textDirQR.text = urls
        let url = NSURL(string: urls!)
        let peticion = NSURLRequest (URL: url!)
        
        browserQR.loadRequest(peticion)
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
