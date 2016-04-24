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
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "SomeEntry")
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true) ]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.appDelegate.manager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

        controller.delegate = self

        return controller
    }()

    var progressValue: Float = 0.0 {
        didSet {
            if progressValue != oldValue {
                dispatch_async(dispatch_get_main_queue()) {
                    self.progressView.progress = self.progressValue
                }
            }
        }
    }

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var progressView: UIProgressView!

    @IBAction func importObjects(sender: UIBarButtonItem) {
        dispatch_async(dispatch_get_main_queue()) { 
            sender.enabled = false

            self.progressView.progress = 0.0
            self.progressView.hidden = false
        }

        for index in 1...1000 {
            appDelegate.manager.performOnWorkerContext { (context) in
                let someEntry = NSEntityDescription.insertNewObjectForEntityForName("SomeEntry", inManagedObjectContext: context) as! SomeEntry

                someEntry.name = "Some Entry \(index)"
                someEntry.createdAt = NSDate()

                self.progressValue = Float(index) / 1000
            }
        }

        dispatch_async(dispatch_get_main_queue()) {
            sender.enabled = true
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
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let insertIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: .Fade)
            }
        case .Delete:
            if let deleteIndexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: .Fade)
            }
        case .Update:
            if let updateIndexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([updateIndexPath], withRowAnimation: .Fade)
            }
        case .Move:
            if let deleteIndexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: .Fade)
            }

            if let insertIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: .Fade)
            }
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        let sectionIndexSet = NSIndexSet(index: sectionIndex)

        switch type {
        case .Insert:
            tableView.insertSections(sectionIndexSet, withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteSections(sectionIndexSet, withRowAnimation: .Fade)
        case .Update:
            tableView.reloadSections(sectionIndexSet, withRowAnimation: .Fade)
        default:
            break
        }
    }

    func controller(controller: NSFetchedResultsController, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }

        return 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        }

        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SomeEntryCell", forIndexPath: indexPath)
        let someEntry = fetchedResultsController.objectAtIndexPath(indexPath) as! SomeEntry

        cell.textLabel?.text = someEntry.name

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(someEntry.createdAt)

        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            return sections[section].name
        }

        return nil
    }
}

extension ViewController: UITableViewDelegate {

}
