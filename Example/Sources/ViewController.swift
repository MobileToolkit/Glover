//
//  ViewController.swift
//  Glover iOS Example
//
//  Created by Sebastian Owodzin on 24/04/2016.
//  Copyright © 2016 mobiletoolkit.org. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    lazy var fetchedResultsController: NSFetchedResultsController<SomeEntry> = {
        let fetchRequest: NSFetchRequest<SomeEntry> = NSFetchRequest(entityName: "SomeEntry")
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true) ]

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let controller = NSFetchedResultsController<SomeEntry>(fetchRequest: fetchRequest, managedObjectContext: appDelegate.manager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

        controller.delegate = self

        return controller
    }()

    var progressValue: Float = 0.0 {
        didSet {
            if progressValue != oldValue {
                DispatchQueue.main.async {
                    self.progressView.progress = self.progressValue
                }
            }
        }
    }

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var progressView: UIProgressView!

    @IBAction func importObjects(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async { 
            sender.isEnabled = false

            self.progressView.progress = 0.0
            self.progressView.isHidden = false
        }

        for index in 1...1000 {
            appDelegate.manager.performOnWorkerContext { (context) in
                let someEntry = NSEntityDescription.insertNewObject(forEntityName: "SomeEntry", into: context) as! SomeEntry

                someEntry.name = "Some Entry \(index)"
                someEntry.createdAt = Date()

                self.progressValue = Float(index) / 1000
            }
        }

        DispatchQueue.main.async {
            sender.isEnabled = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
        }
    }

}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let insertIndexPath = newIndexPath {
                tableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        case .delete:
            if let deleteIndexPath = indexPath {
                tableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
        case .update:
            if let updateIndexPath = indexPath {
                tableView.reloadRows(at: [updateIndexPath], with: .fade)
            }
        case .move:
            if let deleteIndexPath = indexPath {
                tableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }

            if let insertIndexPath = newIndexPath {
                tableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let sectionIndexSet = IndexSet(integer: sectionIndex)

        switch type {
        case .insert:
            tableView.insertSections(sectionIndexSet, with: .fade)
        case .delete:
            tableView.deleteSections(sectionIndexSet, with: .fade)
        case .update:
            tableView.reloadSections(sectionIndexSet, with: .fade)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }

        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SomeEntryCell", for: indexPath)
        let someEntry = fetchedResultsController.object(at: indexPath) 

        cell.textLabel?.text = someEntry.name

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        cell.detailTextLabel?.text = dateFormatter.string(from: someEntry.createdAt)

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            return sections[section].name
        }

        return nil
    }
}

extension ViewController: UITableViewDelegate {

}
