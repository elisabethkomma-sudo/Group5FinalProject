//
//  EditViewController.swift
//  Group5FinalProject
//
//  Created by Komma, Elisabeth A. on 11/13/25.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var edittedInputTextField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        edittedInputTextField.layer.cornerRadius = 10

    }
    
    @IBAction func done(_ sender: Any) {
    }
    
    @IBAction func undo(_ sender: Any) {
    }
    
    @IBAction func trash(_ sender: Any) {
        //show alert to make sure they mean to delete note
    }
    
    
}
