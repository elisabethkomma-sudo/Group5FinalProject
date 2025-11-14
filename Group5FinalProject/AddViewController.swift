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
    }
    
    @IBOutlet weak var inputTextField: UITextView!
    
    
    /*
     
     */

}
