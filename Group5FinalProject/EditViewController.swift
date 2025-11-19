//
//  EditViewController.swift
//  Group5FinalProject
//
//  Created by Komma, Elisabeth A. on 11/13/25.
//

import UIKit
import CoreData

class EditViewController: UIViewController {

    @IBOutlet weak var inputTextView: UITextView!
    
    var noteVC : NotesViewController?
    var segmentType: Int?
    var noteEntity: NSManagedObject?
    var indexPath: IndexPath?
    
    var editVersions: [String] = []
    var lastEdit: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextView.layer.cornerRadius = 10
        
        if let segmentType = segmentType, segmentType == 0{
            overrideUserInterfaceStyle = .light
            inputTextView.tintColor = .white
        }else{
            overrideUserInterfaceStyle = .dark
            inputTextView.tintColor = .black
        }
        
        // set the note text for the inputTextField
        if let text = noteEntity?.value(forKey: "text") {
            inputTextView.text = text as? String
        }
        
        inputTextView.delegate = self
        inputTextView.becomeFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        }
    }
    
    
    @IBAction func save(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        guard let note = self.noteEntity else {return}
        guard let text = inputTextView.text else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // delete the note and return if text field is empty
        guard !text.isEmpty else {
            managedContext.delete(note)
            
            do { try managedContext.save()
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
            
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        // save the new values of the note
        noteEntity?.setValue(text.components(separatedBy: "\n")[0], forKey: "name")
        noteEntity?.setValue(text, forKey: "text")
        noteEntity?.setValue(Date(), forKey: "lastEditTime")
        
        do {try managedContext.save()
        } catch let error as NSError {
            print("Error saving notes list: \(error)")
        }
        
        // return to NotesView
        noteVC?.notesTableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func undo(_ sender: Any) {
        
        if editVersions.count <= 0 {
            inputTextView.text = ""
            lastEdit.removeAll()
        } else {
            inputTextView.text = editVersions.removeLast()
            lastEdit.removeAll()
        }
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
    
}


extension EditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextInRanges ranges: [NSValue], replacementText text: String) -> Bool {
        
        guard !text.isEmpty else {return true}
        
        // lastEdit should hold at most 8 characters before clearing
        if lastEdit.count <= 8 {
            lastEdit.append(text)
        } else {
            // once lastEdit has reached 8 characters
            //  clear it and save the version to editVersions
            lastEdit.removeAll()
            
            if editVersions.count <= 32 {
                editVersions.append(inputTextView.text)
            } else {
                // if editVersions has more than 32 edits, cycle out the oldest edit
                editVersions.removeFirst()
                editVersions.append(inputTextView.text)
            }
        }
        
        return true
    }
}
