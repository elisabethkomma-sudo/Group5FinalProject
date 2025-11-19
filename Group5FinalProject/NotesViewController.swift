//
//  ViewController.swift
//  Group5FinalProject
//
//  Created by Komma, Elisabeth A. on 11/13/25.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    var listOfNotes: [String] = []
    var notesList: [NSManagedObject] = []
    

    @IBOutlet weak var notesTableView: UITableView!
    
    @IBOutlet weak var segmentIndex: UISegmentedControl!
    
    @IBAction func lightDarkSegment(_ sender: Any) {
        if let segment = sender as? UISegmentedControl{
            if segment.selectedSegmentIndex == 0{
                overrideUserInterfaceStyle = .light
            }else if segment.selectedSegmentIndex == 1{
                overrideUserInterfaceStyle = .dark
            }
        }
    }
    
    
    @IBAction func createNote(_ sender: Any) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        
        guard let vc = sb.instantiateViewController(withIdentifier: "EditViewController") as? EditViewController else {
                return
        }
        
        // create new note entity
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SavedNote", in: managedContext)!
        
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        notesList.append(note)
        
        vc.noteVC = self
        vc.segmentType = segmentIndex.selectedSegmentIndex
        vc.noteEntity = note
        
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedNote")
        
        do {
            notesList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error fetching notes list: \(error)")
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if segmentIndex.selectedSegmentIndex == 0{
            overrideUserInterfaceStyle = .light
        }else if segmentIndex.selectedSegmentIndex == 1{
            overrideUserInterfaceStyle = .dark
        }
    }
}


extension NotesViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let note = notesList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = note.value(forKeyPath: "name") as? String
        cell.accessoryView = UIImageView(image: UIImage(named: "arrow"))
        
        let date = note.value(forKeyPath: "lastEditTime") as? Date
        
        let dateString = date?.formatted(
            Date.FormatStyle()
                .year(.defaultDigits)
                .month(.twoDigits)
                .day(.twoDigits)
                .hour(.defaultDigits(amPM: .abbreviated))
                .minute(.twoDigits)
        )
        
        cell.detailTextLabel?.text = dateString
        cell.detailTextLabel?.textColor = UIColor.lightText
        
        return cell
    }
}


extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        
        guard let vc = sb.instantiateViewController(withIdentifier: "EditViewController") as? EditViewController else {
                return
        }
        
        vc.noteVC = self
        vc.noteEntity = notesList[indexPath.row]
        vc.segmentType = segmentIndex.selectedSegmentIndex
        vc.indexPath = indexPath
        
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
