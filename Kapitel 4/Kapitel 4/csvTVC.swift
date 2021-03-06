//
//  csvTVC.swift
//  Kapitel 4
//
//  Created by Udemy on 29.12.14.
//  Copyright (c) 2014 Udemy. All rights reserved.
//

import UIKit

class csvTVC: UITableViewController {

    var daten = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ladeDaten()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hinzufügen", style: .Plain, target: self, action: "addButtonPressed:")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        speicherDaten()
    }
    
    func addButtonPressed(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Hinzufügen", message: "Was soll hinzugefügt werden?", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler {
            textField in
            textField.placeholder = "Name"
        }
        alert.addTextFieldWithConfigurationHandler {
            textField in
            textField.placeholder = "Beschreibung"
        }
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Bestätigen", style: .Default) {
            action in
            let dictionary = ["name": ((alert.textFields?[0])! as UITextField).text!,
                                "beschreibung": ((alert.textFields?[1])! as UITextField).text!]
            self.daten.append(dictionary)
            self.tableView.reloadData()
            })
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daten.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        let name = daten[indexPath.row]["name"]!
        let beschreibung = daten[indexPath.row]["beschreibung"]!
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = beschreibung
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            daten.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Löschen"
    }
    
    func ladeDaten() {
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as [String]
        let dir = dirs.first!
        
        // let path = dir.stringByAppendingPathComponent("daten.csv")
        let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("daten.csv")
        
        // let dataFromPath = NSData(contentsOfFile: path)
        let dataFromPath = NSData.init(contentsOfURL: path)
        
        if let data = dataFromPath {
            
            let stringFromData: String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
            
            daten.removeAll(keepCapacity: true)
            for zeile in stringFromData.componentsSeparatedByString("\n") {
                if zeile == "" { continue }
                let teile = zeile.componentsSeparatedByString(",")
                daten.append(["name": teile[0], "beschreibung": teile[1]])
            }
            tableView.reloadData()
            
        }
    }
    
    func speicherDaten() {
        
        if let dir: NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent("daten.csv")
            
            var stringZumSpeichern = ""
            for dic in daten {
                let name = dic["name"]!
                let beschreibung = dic["beschreibung"]!
                stringZumSpeichern += "\(name),\(beschreibung)\n"
            }
            
            do {
            	try stringZumSpeichern.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
            } catch {
                print("Fehler beim daten.csv anlegen!")
                return
            }
        }
    }
}



















