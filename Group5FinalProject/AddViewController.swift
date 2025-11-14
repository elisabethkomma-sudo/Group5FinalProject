//
//  AddViewController.swift
//  Group5FinalProject
//
//  Created by Komma, Elisabeth A. on 11/13/25.
//

import UIKit

class AddViewController: UIViewController {

    var noteVC : NotesViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.layer.cornerRadius = 10
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
        
    }
    
    
    @IBAction func save(_ sender: Any) {
        guard let text = inputTextField.text, !text.isEmpty else{
            return
        }
        noteVC?.listOfNotes.append(text)
        noteVC?.notesTableView.reloadData()
        dismiss(animated: true)
        //if nothing in text box, don't save note and just go back to home
    }
    
    @IBOutlet weak var inputTextField: UITextView!
    
    
    //if there are any changes in the storyboard you think would help, lmk

}
