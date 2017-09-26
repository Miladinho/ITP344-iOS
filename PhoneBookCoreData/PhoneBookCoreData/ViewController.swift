//
//  ViewController.swift
//  PhoneBookCoreData
//
//  Created by Milad  on 11/30/16.
//  Copyright © 2016 Milad . All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var managedObjectContext : NSManagedObjectContext!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addContactBackGroundView: UIView!
    @IBOutlet weak var addContactInsertFieldsView: UIView!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var numberTextfield: UITextField!
    
    @IBOutlet weak var addContactErrorLabel: UILabel!
    var people : [NSManagedObject] = [NSManagedObject]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector((ViewController.addContactBackgroundViewTapped(_:))))
        self.addContactBackGroundView.addGestureRecognizer(tap)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        
        toggleAddContactMenu(off: true)
        
        let _ = retrievePhoneBook()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func retrievePhoneBook() -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")

        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            self.people = results as! [NSManagedObject]
            for person in people {
                print(person.value(forKey: "name"))
                
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        return people
    }
    
    func saveNameAndNumber(name: String, number: String) -> Bool {
        
        let entity =  NSEntityDescription.entity(forEntityName: "Person",in:managedObjectContext)
        
        let person = NSManagedObject(entity: entity!,insertInto: managedObjectContext)
        person.setValue(name, forKey: "name")
        person.setValue(number, forKey: "number")
        
        do {
            try self.managedObjectContext.save()
            people.append(person)
            return true
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            return false
        }
    }

    func toggleAddContactMenu(off: Bool) {
        self.addContactBackGroundView.isHidden = off
        self.nameTextfield.text = ""
        self.numberTextfield.text = ""
    }
    
    func addContactBackgroundViewTapped(_ gesture: UITapGestureRecognizer) {
        toggleAddContactMenu(off: true)
    }

    @IBAction func createContactButtonTapped(_ sender: AnyObject) {
        
        let name : String? = nameTextfield.text
        let number : String? = numberTextfield.text
        
        if ((name == nil) || (number == nil) || (number!.isEmpty) || (number!.isEmpty)) {
            self.addContactErrorLabel.text = "Input Error"
            return
        }
        let status = saveNameAndNumber(name: name!, number: number!)
        if status {
            toggleAddContactMenu(off: true)
            self.tableView.reloadData()
        } else {
            self.addContactErrorLabel.text = "Internal Error"
        }
    }
    
    
    @IBAction func addContactButtonTouched(_ sender: AnyObject) {
        toggleAddContactMenu(off: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = people[indexPath.row].value(forKey: "name") as! String?
        cell?.detailTextLabel?.text = people[indexPath.row].value(forKey: "number") as! String?
        
        return cell!
    }
    
}

