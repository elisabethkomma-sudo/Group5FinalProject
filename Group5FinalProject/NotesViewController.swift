//
//  ViewController.swift
//  Group5FinalProject
//
//  Created by Komma, Elisabeth A. on 11/13/25.
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var notesTableView: UITableView!
    
    
    var listOfNotes: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? AddViewController{
            vc.noteVC = self
        }
    }
    

}


extension NotesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = listOfNotes[indexPath.row]
        return cell
    }
    
    
}
