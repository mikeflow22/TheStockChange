//
//  CoreDataStack.swift
//  StockChange
//
//  Created by Michael Flowers on 3/20/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    //step2
    //create a singleton
    static let shared = CoreDataStack()
    
    //step 3: create a container to hold the stack
    let container: NSPersistentContainer = {
        //create this container to be run later, when someone asks for it instead of immediately
        let container = NSPersistentContainer(name: "Stock")
        //step 4 tell the container what to do
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //step 5 create the context (MOC)
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}

