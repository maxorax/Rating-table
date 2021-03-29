//
//  RedactorViewController.swift
//  Rating table
//
//  Created by Maxorax on 28.03.2021.
//

import UIKit
import CoreData
class RedactorViewController: UIViewController {
    var name = ""
    var lastName = ""
    var mark: Int16 = 0
    var student: Student!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var markTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
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
                student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: managedObjectContext) as? Student
                
                student.name = nameTF.text!
                student.lastName = lastNameTF.text!
                student.mark = Int16(markTF.text!)!
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        } catch{
            alert(error: error)
        }
       
       
        
    }
    
    func valid() throws {

        guard let n = nameTF.text, n != "" else {
            throw ValidateError.wrongName

        }
        guard let l = lastNameTF.text, l != "" else {

            throw ValidateError.wrongLastName
        }
        guard let m = Int16(markTF.text!), m > 0, m <= 5 else {
            throw ValidateError.wrongMark
        }
    }
    
    func alert(error: Error){
        var message: String
        switch error {
        case ValidateError.wrongName:
           message = "Неправильно введено имя!"
        case ValidateError.wrongLastName:
            message = "Неправильно введена фамилия!"
        case ValidateError.wrongMark:
            message = "Неправильно введен средний балл!"
        default:
            message = error.localizedDescription
        }
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ок", style: .default, handler: nil)

        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
