//
//  TablaEventosTableViewController.swift
//  MyPlaces
//
//  Created by Nicolás Narria on 8/1/16.
//  Copyright © 2016 Nicolás Narria. All rights reserved.
//

import UIKit

class TablaEventosTableViewController: UITableViewController {
    var eventos: [Evento] = [Evento]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.recuperarDatos()
        
        
    }

    
    func recuperarDatos () {
        let url = "http://plataforma.promexico.gob.mx/sys/gateway.aspx?UID=d3e37eea-b6a1-416e-806d-ae90a5983600&formato=JSON"
        let urls = NSURL(string: url)
        let datos = NSData(contentsOfURL: urls!)

        //print (datos)
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableContainers)
            
            let dico1 = json as! NSDictionary
            let dico2 = dico1["caleventos"] as! NSArray as Array
            
            for event in dico2 {
                let eventoTmp = Evento ()
                eventoTmp.feria = event["FERIA"] as! NSString as String
                eventoTmp.fecha = event["FECHA"] as! NSString as String
                eventoTmp.ciudadPais = event["CIUDAD_PAIS"] as! NSString as String
                eventoTmp.sector = event["SECTOR"] as! NSString as String
                eventoTmp.tipo = event["TIPO_EVENTO"] as! NSString as String
                
                self.eventos.append(eventoTmp)
            }
        }
        catch {
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.eventos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("celdaEvento", forIndexPath: indexPath) as! CeldaEventoTableViewCell
        

        // Configure the cell...
        //cell.textLabel?.text = self.ciudades[indexPath.row][0]
        cell.feria.text = self.eventos[indexPath.row].feria
        cell.fecha.text = self.eventos[indexPath.row].fecha
        cell.ciudadPais.text = self.eventos[indexPath.row].ciudadPais
        cell.tipo.text = self.eventos[indexPath.row].tipo
        
        //cell.textLabel?.text = self.eventos[indexPath.row].feria
        //cell.detailTextLabel?.text = self.eventos[indexPath.row].ciudadPais
        //cell.imageView?.image = self.rutas[indexPath.row].imagen
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
