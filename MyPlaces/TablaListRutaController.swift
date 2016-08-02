//
//  TablaListRutaController.swift
//  MyPlaces
//
//  Created by Nicolás Narria on 7/20/16.
//  Copyright © 2016 Nicolás Narria. All rights reserved.
//

import UIKit
import MapKit
import CoreData



class TablaListRutaController: UITableViewController, TransferirListPunto {

    private var rutas = [Ruta]()
    var contexto: NSManagedObjectContext? = nil
    
    private var indexRowUpdate: Int = 0
    
    func transferir(listPunto : [MKMapItem], indexRuta: Int) {
        
        let nombreRuta = self.rutas[indexRuta].nombre
        
        let rutaEntidad = NSEntityDescription.entityForName("Ruta", inManagedObjectContext: self.contexto!)
        let peticion = rutaEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petRuta", substitutionVariables: ["nombre": nombreRuta])
            
            
        do {
            let rutaEntidad_ = try self.contexto?.executeFetchRequest(peticion!)
                
            if (rutaEntidad_?.count == 0) {
                return
            }
            
            var llPunto = [Punto]()
            for p in listPunto {
                let longitud = p.placemark.coordinate.longitude
                let latitud = p.placemark.coordinate.latitude
                let nnombre = p.placemark.name
                
                let puntoTmp = Punto(longitud: longitud, latitud: latitud, nombre: nnombre!)
                llPunto.append(puntoTmp)
            }
            
            rutaEntidad_![0].setValue(crearPuntosEntidad(llPunto), forKey: "posee")
        }
        catch {
        }
            
        do {
            try self.contexto?.save()
        }
        catch {
        }
        
        self.rutas[indexRuta].puntos.removeAll()
        
        for p in listPunto {
            self.rutas[indexRuta].puntos.append(p)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        
        let rutaEntidad = NSEntityDescription.entityForName("Ruta", inManagedObjectContext: self.contexto!)
        
        /*
        let peticion = rutaEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petRuta", substitutionVariables: ["nombre": "ruta1"])
        */
        let peticion = rutaEntidad?.managedObjectModel.fetchRequestTemplateForName("petRutas")
        
        do {
            let rutaEntidad = try self.contexto?.executeFetchRequest(peticion!)
            
            
            for ruta_ in rutaEntidad! {
                let nombre = ruta_.valueForKey("nombre") as! String
                let descripcion = ruta_.valueForKey("descripcion") as! String
                let imagen = ruta_.valueForKey("imagen") as! NSData
                let puntosEntidad = ruta_.valueForKey("posee") as! Set<NSObject>
                
                
                var ppuntos = [MKMapItem]()
                for punto in puntosEntidad {
                    let nombrePunto_ = punto.valueForKey("nombre") as! String
                    let latitudPunto_ = punto.valueForKey("latitud") as! Double
                    let longitudPunto_ = punto.valueForKey("longitud") as! Double
                    
                    
                    let puntoCoor = CLLocationCoordinate2D(latitude: latitudPunto_, longitude: longitudPunto_)
                    let puntoLugar = MKPlacemark (coordinate: puntoCoor, addressDictionary: nil)
                    
                    let puntoMK = MKMapItem(placemark: puntoLugar)
                    puntoMK.name = nombrePunto_

                    ppuntos.append(puntoMK)
                }
                
                let ruta_ = Ruta (puntos: ppuntos, nombre: nombre, descripcion: descripcion, imagen: UIImage(data: imagen))
                self.rutas.append(ruta_)   
                
            }
            
            /*
            if (rr?.count > 0) {
                return
            }
            */
        }
        catch {
            
        }
        
        

        /*
        self.rutas.append(Ruta(puntos: [], nombre: "Pepito1", descripcion: "p1", imagen: nil))
        self.rutas.append(Ruta(puntos: [], nombre: "Pepito2", descripcion: "p2", imagen: nil))
        self.rutas.append(Ruta(puntos: [], nombre: "Pepito3", descripcion: "p3", imagen: nil))
        */
        
        /*
        self.ciudades.append(["Caracas", "cod1"])
        self.ciudades.append(["Paris", "cod2"])
        self.ciudades.append(["Grenoble", "cod3"])
        */
        
        /*
        self.navigationItem.title = "probando"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(TablaListRutaController.insertRuta) )
        */
    
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //self.tableView.allowsMultipleSelectionDuringEditing = true
        
        
        
        //tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(false, animated: false)
        
    }
    

    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        print ("hello: " + segue.identifier!)
        
        
        if (segue.identifier! == "aplicar") {
            
            
            let nuevaRuta = segue.sourceViewController as! NuevaRutaTableViewController
            
            
            var nn = nuevaRuta.nombreRuta.text!
            nn = nn.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            if (nn.characters.count > 0) {
            
                //print ("nombre de la nueva ruta: " + nuevaRuta.nombreRuta.text!)
                //self.ciudades.append([nuevaRuta.nombreRuta.text!, "cod10"])
            
                let img = nuevaRuta.fotoVista.image
            
                /*
                if (img != nil) {
                    img = self.ResizeImage(img!, targetSize: CGSizeMake(40.0, 40.0))
                }
                */
            
                let rr = Ruta(puntos: [], nombre: nuevaRuta.nombreRuta.text!, descripcion: "" + nuevaRuta.descripcionRuta.text!, imagen: img)
                
                
                let nuevaRutaEntidad = NSEntityDescription.insertNewObjectForEntityForName("Ruta", inManagedObjectContext: self.contexto!)
                
                nuevaRutaEntidad.setValue(nuevaRuta.nombreRuta.text!, forKey: "nombre")
                nuevaRutaEntidad.setValue(nuevaRuta.descripcionRuta.text!, forKey: "descripcion")
                nuevaRutaEntidad.setValue(UIImagePNGRepresentation(img!), forKey: "imagen")
                
                //nuevaRutaEntidad.setValue(crearPuntosEntidad([]), forKey: "posee")
                
                do {
                    try self.contexto?.save()
                }
                catch {
                    
                }
                
                
                
                self.rutas.append(rr)
            }
            
            
        }
        
        if (segue.identifier! == "editar") {
            let editarRuta = segue.sourceViewController as! EditarRutaTableViewController

            var nn = editarRuta.nombreRuta.text!
            nn = nn.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            if (nn.characters.count > 0) {
            
            
                let rutaEntidad = NSEntityDescription.entityForName("Ruta", inManagedObjectContext: self.contexto!)
                let peticion = rutaEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petRuta", substitutionVariables: ["nombre": self.rutas[self.indexRowUpdate].nombre])
            
            
                do {
                    let rutaEntidad_ = try self.contexto?.executeFetchRequest(peticion!)
                    //print ("cantidad regreso: \(rutaEntidad_?.count)")
                
                    if (rutaEntidad_?.count == 0) {
                        return
                    }
                
                    rutaEntidad_![0].setValue(editarRuta.nombreRuta.text!, forKey: "nombre")
                    rutaEntidad_![0].setValue(editarRuta.descripcionRuta.text!, forKey: "descripcion")
                    rutaEntidad_![0].setValue(UIImagePNGRepresentation(editarRuta.iRuta), forKey: "imagen")
                }
                catch {
                }
            
                do {
                    try self.contexto?.save()
                }
                catch {
                }
            
                self.rutas[self.indexRowUpdate].nombre = editarRuta.nombreRuta.text!
                self.rutas[self.indexRowUpdate].descripcion = editarRuta.descripcionRuta.text!
                self.rutas[self.indexRowUpdate].imagen = editarRuta.iRuta

                //print("debo editar: \(self.indexRowUpdate)")
            }
        }
        
        
        self.tableView.reloadData()
        
    }
    
    func crearPuntosEntidad (puntos: [Punto]) -> Set<NSObject> {
        var entidades = Set<NSObject>()
        
        for p in puntos {
            let puntoEntidad = NSEntityDescription.insertNewObjectForEntityForName("Punto", inManagedObjectContext: self.contexto!)
            let latitud = p.latitud
            let longitud = p.longitud
            let nombre = p.nombre
            
            puntoEntidad.setValue(latitud, forKey: "latitud")
            puntoEntidad.setValue(longitud, forKey: "longitud")
            puntoEntidad.setValue(nombre, forKey: "nombre")
            
            entidades.insert(puntoEntidad)
        }
        
        return entidades
        
    }
    
    
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
     
        
        return newImage
    }

    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return self.ciudades.count
        return self.rutas.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Celda", forIndexPath: indexPath)

        // Configure the cell...
        //cell.textLabel?.text = self.ciudades[indexPath.row][0]
        cell.textLabel?.text = self.rutas[indexPath.row].nombre
        cell.imageView?.image = self.rutas[indexPath.row].imagen
        //cell.i
        
        return cell
    }
    

    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
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
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        
        let update = UITableViewRowAction(style: .Normal, title: "Update", handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            //print("update")
            self.indexRowUpdate = indexPath.row
            self.performSegueWithIdentifier("irDataRuta", sender: indexPath)
            }
        )
        
        /*
        let update = UITableViewRowAction(style: .Normal, title: "Update") { action, index in
            print("update")
            self.performSegueWithIdentifier("irDataRuta", sender: indexPath)
            
        }
        */
 
        let delete = UITableViewRowAction(style: .Default, title: "Delete") { action, index in
            //print("Delete")
            
            
            let nombreRuta = self.rutas[indexPath.row].nombre
            //print ("buscar ruta: " + nombreRuta)
            
            
            
            let rutaEntidad = NSEntityDescription.entityForName("Ruta", inManagedObjectContext: self.contexto!)
            let peticion = rutaEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petRuta", substitutionVariables: ["nombre": nombreRuta])
 
            
            do {
                let rutaEntidad_ = try self.contexto?.executeFetchRequest(peticion!)
                //print ("cantidad regreso: \(rutaEntidad_?.count)")
            
                if (rutaEntidad_?.count == 0) {
                    return
                }
                
                self.contexto?.deleteObject(rutaEntidad_![0] as! NSManagedObject)
            }
            catch {
            }
            
            do {
                try self.contexto?.save()
            }
            catch {
                
            }

            
            self.rutas.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
        return [delete, update]
    }
    

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
    
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if  (segue.identifier == "irDataRuta") {
            let destination = segue.destinationViewController as? EditarRutaTableViewController
            let rutaIndex = (sender as? NSIndexPath)?.row
        
            //print ("celda actual: \(rutaIndex)!")
            destination?.nRuta = ""+self.rutas[rutaIndex!].nombre
            destination?.dRuta = ""+self.rutas[rutaIndex!].descripcion
            destination?.iRuta = self.rutas[rutaIndex!].imagen

        }
        
        if (segue.identifier == "irMapa") {
            //print("ir a MAPAAAA")
            
            let svc = segue.destinationViewController as! VistaMapaController
            svc.delegado_ = self
            let iRuta = self.tableView.indexPathForSelectedRow?.row
            svc.indexRuta = iRuta
            svc.nombreRuta = self.rutas[iRuta!].nombre
            svc.imgRuta = self.rutas[iRuta!].imagen
            
            
            
            svc.listaPunto.removeAll()
            
            for p in self.rutas[iRuta!].puntos {
                svc.listaPunto.append(p)
            }
        }
        
                
        
        /*
            print ("celda actual dd: \(self.currentCell)!")
            
            viewController.nRuta = ""
            viewController.dRuta = ""
            viewController.iRuta = nil
        }*/
        
    }
    

}
