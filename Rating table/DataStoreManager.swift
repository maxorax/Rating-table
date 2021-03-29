//
//  DataStoreManager.swift
//  Rating table
//
//  Created by Maxorax on 30.03.2021.
//

import Foundation
import CoreData
class DataStoreManager{
    
    // MARK: - Core Data stack

//    @available(iOS 10.0, *)
//    lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext
//
//
//    @available(iOS 10.0, *)
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Rating table")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    @available(iOS 10.0, *)
//    func obtainStudent() -> [Student]? {
//
//        if let student = try? viewContext.fetch(Student.fetchRequest()) as? [Student], !student.isEmpty  {
//            return student
//        } else { return nil }
//    }
//
//    @available(iOS 10.0, *)
//    func saveStudent(name: String , lastName: String, mark: Int16){
//        let student = Student(context: viewContext)
//        student.name = name
//        student.lastName = lastName
//        student.mark = mark
//        do {
//            try viewContext.save()
//        } catch let error {
//            print("Error: \(error)")
//        }
//    }
//
//    // MARK: - Core Data Saving support
//
//    @available(iOS 10.0, *)
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
    
    //MARK: - IOS 9
    
    static let moduleName = "StudentCoreData"
        
        lazy var mainMoc: NSManagedObjectContext = {
            let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            moc.persistentStoreCoordinator = self.coordinator
            
            moc.mergePolicy =  NSMergeByPropertyObjectTrumpMergePolicy
            
            return moc
        }()

        private lazy var model: NSManagedObjectModel = {
            guard let modelURL = Bundle.main.url(forResource: DataStoreManager.moduleName,
                                                                withExtension: "momd")
            else {
                fatalError("Ошибка при загрузке model из bundle")
            }
            guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
                
                fatalError("Ошибка инициализации модели mom из: \(modelURL)")
            }
            return mom
        }()

      private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
      }()

      private lazy var coordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)

        let persistentStoreURL =
            self.applicationDocumentsDirectory.appendingPathComponent("\(DataStoreManager.moduleName).sqlite")
        //print (persistentStoreURL)

        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: persistentStoreURL,
                                          options: [NSMigratePersistentStoresAutomaticallyOption: true,
           NSInferMappingModelAutomaticallyOption: false])
        } catch {
          fatalError("Ошибка Persistent store! \(error)")
        }
        return coordinator
      }()
        
        func saveMainContext() {
            if mainMoc.hasChanges {
                do {
                    try mainMoc.save()
                } catch  {
                    fatalError("Ошибка сохранения main managed object context! \(error)")
                }
            }
        }
    
    
}
