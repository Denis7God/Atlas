//
//  MainManagedObjectContext.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 16.12.2020.
//

import UIKit
import CoreData

class MainManagedObjectContext {
    
    static var shared: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}
