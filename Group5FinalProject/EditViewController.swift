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
    }
    
    @IBAction func addImage(_ sender: Any) {
        //if an image is added, it should show the first one added on the note cell title
    }
    
}
