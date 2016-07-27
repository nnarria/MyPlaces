//
//  ViewController.swift
//  MyPlaces
//
//  Created by Nicolás Narria on 7/20/16.
//  Copyright © 2016 Nicolás Narria. All rights reserved.
//

import UIKit

class MenuPrincipalVC: UIViewController {
    var msg: String = ""
    var count: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func irListRuta(sender: AnyObject) {
        let nvc = self.navigationController
        count += 1
        msg = "hola: "
        nvc?.performSegueWithIdentifier("toListRuta", sender: self)
        
        
    }

}

