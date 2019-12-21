//
//  ViewController.swift
//  HitList(CoreData)
//
//  Created by Eugene Bagaev on 20.12.2019.
//  Copyright © 2019 Eugene Bagaev. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    
    var people = [NSManagedObject] ()
       
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction  func saveName(name: String) {
              
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
              
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)
         
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        person.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            
            people.append(person)
           
        } catch let error as NSError {
            
            print("Couldnt save. \(error), \(error.userInfo)")
        }
        
    }
    
    
    
    @IBAction func addName(_ sender: UISwitch) {
    
        var alert = UIAlertController(title: "New name", message: "Add new name", preferredStyle: .alert)
    
        let saveAction = UIAlertAction(title: "Save", style: .default) { (actioin : UIAlertAction!)-> Void in
            
            let textField = alert.textFields![0] as! UITextField
            
            
            
            self.saveName(name: textField.text!)
            self.tableView.reloadData()
        }
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)  {(action: UIAlertAction)-> Void in}
              
        let NameTextField :((UITextField)-> Void)? = {
             txtField in
            
            txtField.placeholder = ""
            
            
        }
        
        alert.addTextField(configurationHandler : NameTextField!)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
    }

    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
           
        let person = people[indexPath.row]
        cell.textLabel!.text = person.value(forKey: "name") as? String
           
           return cell
       }
              
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              return people.count
          }
    
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
            
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject> (entityName: "Person")

        do {
            
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch.\(error), \(error.userInfo)")
        
        }
        }
        
        
    }
    
    
    
    



