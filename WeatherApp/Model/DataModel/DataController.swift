//
//  DataController.swift
//  WeatherApp
//
//  Created by Gondai Mgano on 28/4/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//


import Foundation
import CoreData

class DataController{
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    init(modelName:String) {
        
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(){
        persistentContainer.loadPersistentStores{
            store,error in
            guard error==nil else {
                fatalError(error!.localizedDescription)
            }
            
          
            
        }
        }
   static  let shared = DataController(modelName: "WeatherDB")
}
