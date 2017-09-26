//
//  PhoneBookCoreDataTests.swift
//  PhoneBookCoreDataTests
//
//  Created by Milad  on 11/30/16.
//  Copyright © 2016 Milad . All rights reserved.
//

import XCTest
import CoreData
@testable import PhoneBookCoreData

class PhoneBookCoreDataTests: XCTestCase {
    
    var vc : ViewController!
    var managedObjectContext : NSManagedObjectContext!
    var sizeOfTestPhoneBook : Int!
    
    override func setUp() {
        super.setUp()
        self.vc = ViewController()
        self.sizeOfTestPhoneBook = 0
        self.managedObjectContext = setUpInMemoryManagedObjectContext()
        if managedObjectContext.persistentStoreCoordinator == nil {
            print( "failed to add in-memory persistent")
            XCTFail()
        } else {
            self.vc.managedObjectContext = self.managedObjectContext
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        let managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }
    
    func testRetrievePhoneBook() {
        XCTAssert(vc.retrievePhoneBook().count == sizeOfTestPhoneBook, "App should retrieve all phone book data")
    }

    func testAddNewContact() {
        self.vc.saveNameAndNumber(name: "Milad", number: "3107178283")
        XCTAssert(self.managedObjectContext.value(forKey: "name") as! String == "Milad", "Added contact name is correct")
        XCTAssert(self.managedObjectContext.value(forKey: "number") as! String == "3107178283", "Added contact number is correct")
    }
    
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //        let entity = NSEntityDescription.insertNewObject(forEntityName: "Person", into: managedObjectContext)
    //        entity.setValue("3107178283", forKey: "number")
    //        entity.setValue("Milad", forKey: "name")
    //        do {
    //            try managedObjectContext.save()
    //        } catch {
    //            print("could not save entity for test")
    //        }

    
}
