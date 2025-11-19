//
//  ViewController.swift
//  Group5FinalProject
//
//  Created by Komma, Elisabeth A. on 11/13/25.
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var notesTableView: UITableView!
    
    @IBAction func lightDarkSegment(_ sender: Any) {
        if let segment = sender as? UISegmentedControl{
            if segment.selectedSegmentIndex == 0{
                overrideUserInterfaceStyle = .light
            }else if segment.selectedSegmentIndex == 1{
                overrideUserInterfaceStyle = .dark
            }
        }
    }
    
    @IBOutlet weak var segmentIndex: UISegmentedControl!
    
    var listOfNotes: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if segmentIndex.selectedSegmentIndex == 0{
            overrideUserInterfaceStyle = .light
        }else if segmentIndex.selectedSegmentIndex == 1{
            overrideUserInterfaceStyle = .dark
        }
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? AddViewController{
            vc.noteVC = self
            vc.segmentType = segmentIndex.selectedSegmentIndex
        }
        if let vc2 = segue.destination.children.first as? EditViewController{
            vc2.segmentType = segmentIndex.selectedSegmentIndex
        }
        
        
    }
    
    //maybe it can show when the note was last edited on the footer of the cell?
    

}


extension NotesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = listOfNotes[indexPath.row]
        cell.accessoryView = UIImageView(image: UIImage(named: "arrow"))
        
        return cell
    }
    
    
}
