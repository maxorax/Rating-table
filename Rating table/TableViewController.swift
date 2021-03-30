//
//  TableViewController.swift
//  Rating table
//
//  Created by Maxorax on 28.03.2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var name = ""
    var lastName = ""
    var mark: Int16 = 0
    var indexCell: IndexPath? = nil
    var students: [Student] = []
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.title = "отмена"
        tableView.delegate = self
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                students = fetchResultController.fetchedObjects as! [Student] 
            } catch {
                print(error)
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
         name = ""
         lastName = ""
         mark = 0
         indexCell = nil
//        do {
//            try fetchResultController.performFetch()
//            students = fetchResultController.fetchedObjects as! [Student]
//        } catch {
//            print(error)
//        }
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let _newIndexPath = newIndexPath {
                tableView.insertRows(at: [_newIndexPath], with: .fade)
            }
        case .delete:
            if let _newIndexPath = newIndexPath {
                tableView.deleteRows(at: [_newIndexPath], with: .fade)
            }
        case .update:
            if let _newIndexPath = newIndexPath {
                tableView.reloadRows(at: [_newIndexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        students = controller.fetchedObjects as! [Student]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
//    @IBAction func unwindToRedactroViewController(_ unwindSegue: UIStoryboardSegue) {
//        let sourceViewController = unwindSegue.source as! RedactorViewController
//
//
//
//
//        self.name = sourceViewController.nameTF.text!
//        self.lastName = sourceViewController.lastNameTF.text!
//        self.mark = sourceViewController.markTF.text!
//        if(name != "" && lastName != "" && mark != ""){
//            students.append(Student(name: sourceViewController.nameTF.text!, lastName: sourceViewController.lastNameTF.text!, mark: sourceViewController.markTF.text!))
//
//        } else {
//            sourceViewController.name = ""
//            sourceViewController.lastName = ""
//            sourceViewController.mark = ""
//            sourceViewController.alert()
//
//        }
//        print("\(name) \(lastName) \(mark)")
//    }
//
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return students.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell
        let number = students[indexPath.row]
       
        cell.fullNameLabel.text = "\(number.name) \(number.lastName)"
        cell.fullNameLabel.sizeToFit()
        cell.markLabel.text = "\(number.mark)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        name = students[indexPath.row].name
        lastName = students[indexPath.row].lastName
        mark = students[indexPath.row].mark
        indexCell = indexPath
        tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.white
        performSegue(withIdentifier: "addEditSegue", sender: self)
    }
    
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
//     Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                
                let studentToDelete = self.fetchResultController.object(at: indexPath) as! Student
                managedObjectContext.delete(studentToDelete)
                students.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)

                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
                
                
            }
        }
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? RedactorViewController {
                dest.name = self.name
                dest.lastName = self.lastName
                dest.mark = self.mark
                //dest.indexCell = self.indexCell
//                dest.students = self.students
        }
    }
}
