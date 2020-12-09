//
//  ViewController.swift
//  DesafioCoreData
//
//  Created by Cesar A. Tavares on 09/12/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var textFieldTask: UITextField!
    @IBOutlet weak var tableViewTasks: UITableView!
    var arrayTasks = [Task]()
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "DesafioCoreData")
            container.loadPersistentStores(completionHandler: { _, error in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewTasks.delegate = self
        tableViewTasks.dataSource = self
        
        reloadTasks()
        
    }
    
    func reloadTasks() {
        loadData { (arrayTasks) in
            if let array = arrayTasks {
                self.arrayTasks = array
            }
            DispatchQueue.main.async {
                self.tableViewTasks.reloadData()
            }
        }
    }
    
    func loadData(completion: ([Task]?) -> Void) {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let result = try? context.fetch(request)
        let arrayTasks = result as? [Task]
        completion(arrayTasks)
    }
    
    func saveTask(taskName: String) {
        let context = persistentContainer.viewContext
        let task = Task(context: context)
        task.name = taskName
        try? context.save()
        
        reloadTasks()
    }
    
    func editTask(id: NSManagedObjectID) {
        let context = persistentContainer.viewContext
        let task = context.object(with: id) as? Task
        task?.iscompleted = !task!.iscompleted

        try? context.save()
        
        reloadTasks()
    }
    
    func deleteTask(id: NSManagedObjectID) {
        let context = persistentContainer.viewContext
        let task = context.object(with: id)
        context.delete(task)
        
        try? context.save()
    }
    
    @IBAction func actionButtonAddTask(_ sender: Any) {
        if textFieldTask.text != "" {
            saveTask(taskName: textFieldTask.text!)
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let alert = UIAlertAction
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Deletar") { (action, view, completion) in
            self.deleteTask(id: self.arrayTasks[indexPath.row].objectID)
            self.reloadTasks()
            completion(true)
        }
        let title = arrayTasks[indexPath.row].iscompleted ? "Desmarcar" : "Completar"
        let editAction = UIContextualAction(style: .normal, title: title) { (action, view, completion) in
            self.editTask(id: self.arrayTasks[indexPath.row].objectID)
            self.reloadTasks()
            completion(true)
        }
        
        deleteAction.backgroundColor = UIColor.red
        //editAction.backgroundColor = UIColor.yellow
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskViewCell", for: indexPath) as! TaskViewCell
        cell.setup(task: arrayTasks[indexPath.row])
        return cell
    }
    
    
}

