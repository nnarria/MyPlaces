//
//  CeldaEventoTableViewCell.swift
//  MyPlaces
//
//  Created by Nicolás Narria on 8/1/16.
//  Copyright © 2016 Nicolás Narria. All rights reserved.
//

import UIKit

class CeldaEventoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var feria: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var ciudadPais: UILabel!
    @IBOutlet weak var tipo: UILabel!
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
