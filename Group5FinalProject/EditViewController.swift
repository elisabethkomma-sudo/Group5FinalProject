//
//  EditViewController.swift
//  Group5FinalProject
//
//  Created by Komma, Elisabeth A. on 11/13/25.
//

import UIKit
import CoreData

class EditViewController: UIViewController {

    @IBOutlet weak var inputTextField: UITextView!
    
    var noteVC : NotesViewController?
    var segmentType: Int?
    var noteEntity: NSManagedObject?
    var indexPath: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.layer.cornerRadius = 10
        
        if let segmentType = segmentType, segmentType == 0{
            overrideUserInterfaceStyle = .light
            inputTextField.tintColor = .white
        }else{
            overrideUserInterfaceStyle = .dark
            inputTextField.tintColor = .black
        }
        
        
        // set the note text for the inputTextField
        if let text = noteEntity?.value(forKey: "text") {
            inputTextField.text = text as? String
        }
        
    }
    
    @IBAction func save(_ sender: Any) {
        guard let text = inputTextField.text else {
            return
        }
        
        // delete the note and return if text field is empty
        guard !text.isEmpty else {
            dismiss(animated: true)
            return
        }
        
        
        // save the new values of the note
        noteEntity?.setValue(text.components(separatedBy: "\n")[0], forKey: "name")
        noteEntity?.setValue(text, forKey: "text")
        noteEntity?.setValue(Date(), forKey: "lastEditTime")
        
        // return to NotesView
        noteVC?.notesTableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func undo(_ sender: Any) {
    }
    
    @IBAction func trash(_ sender: Any) {
        //show alert to make sure they mean to delete note
        let alert = UIAlertController(title: "Delete Note?", message: "Would you like to delete this note?", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Delete", style: .default) { UIAlertAction in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            guard let note = self.noteEntity else {return}
            
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(note)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error saving notes list: \(error)")
            }
            
            if let indexPath = self.indexPath {
                // remove from notesList array
                self.noteVC?.notesList.remove(at: indexPath.row)
                
                // remove from notesTableView
                self.noteVC?.notesTableView.deleteRows(at: [indexPath], with: .fade)
                self.noteVC?.notesTableView.reloadData()
            }
            
            // return to NotesView
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    @IBAction func addImage(_ sender: Any) {
        //if an image is added, it should show the first one added on the note cell title
    }
    
}
