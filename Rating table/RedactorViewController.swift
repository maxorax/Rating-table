//
//  RedactorViewController.swift
//  Rating table
//
//  Created by Maxorax on 28.03.2021.
//

import UIKit
import CoreData
class RedactorViewController: UIViewController, NSFetchedResultsControllerDelegate {
    var name = ""
    var lastName = ""
    var mark: Int16 = 0
    var student: Student!
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var markTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 1.0
        saveButton.clipsToBounds = true
        nameTF.text = name
        lastNameTF.text = lastName
        guard mark == 0 else {
            markTF.text = "\(mark)"
            return
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveData(_ sender: Any){
        do {
            try  valid()
            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
                fetchRequest.predicate = NSPredicate(format: "name == %@ AND lastName == %@", nameTF.text!, lastNameTF.text!)
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
                fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
                fetchResultController.delegate = self
                do {
                    try fetchResultController.performFetch()
                } catch {
                    print(error)
                }
                if fetchResultController?.fetchedObjects?.count ?? 0 > 0 {
                    student = fetchResultController.fetchedObjects![0] as? Student
                    student.setValue(nameTF.text!, forKey: "name")
                    student.setValue(lastNameTF.text!, forKey: "lastName")
                    student.setValue(Int16(markTF.text!)!, forKey: "mark")
                } else {
                    student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: managedObjectContext) as? Student
                    student.name = nameTF.text!
                    student.lastName = lastNameTF.text!
                    student.mark = Int16(markTF.text!)!
                }
                do {
                    try student.managedObjectContext?.save()
                    
                } catch {
                    print(error)
                }
            }
        } catch{
            alertError(error: error)
        }
            return
    }
        
    
    func valid() throws {
        guard let _ = nameTF.text?.range(of: "^[a-zA-zа-яА-ЯёЁ]+$", options: .regularExpression) else {
            throw ValidateError.wrongName
        }
        guard let _ = lastNameTF.text?.range(of: "^[a-zA-zа-яА-ЯёЁ]+$", options: .regularExpression) else {
            throw ValidateError.wrongLastName
        }
        guard let m = Int16(markTF.text!), m > 0, m <= 5 else {
            throw ValidateError.wrongMark
        }
    }
    
    func alertError(error: Error){
        var message: String
        switch error {
        case ValidateError.wrongName:
           message = "Неправильно введено имя! В поле Имя должны содержаться только русские или английские символы без пробелов."
        case ValidateError.wrongLastName:
            message = "Неправильно введена фамилия! В поле Фамилия должны содержаться только русские или английские символы без пробелов."
        case ValidateError.wrongMark:
            message = "Неправильно введен средний балл! В поле Средний балл только целое число от 1 до 5."
        default:
            message = error.localizedDescription
        }
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ок", style: .default, handler: nil)

        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
