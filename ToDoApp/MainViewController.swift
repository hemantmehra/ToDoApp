//
//  ViewController.swift
//  ToDoApp
//
//  Created by Hemant Mehra on 29/06/17.
//  Copyright © 2017 Hemant Mehra. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskCellDelegate {

    @IBOutlet var visualBlur: UIVisualEffectView!
    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var addTaskView: UIView!
    @IBOutlet weak var addTaskField: UITextField!
    
    var taskList: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTaskView.layer.cornerRadius = 5
        taskTable.dataSource = self
        taskTable.delegate = self
        taskTable.tableFooterView = UIView(frame: .zero)
        
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do{
            try taskList = context.fetch(request)
            self.taskTable.reloadData()
        }catch{
            print("Error while fetching.")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func popup(_ sender: Any) {
        self.view.addSubview(visualBlur)
        visualBlur.center = self.view.center
        self.view.addSubview(addTaskView)
        addTaskView.alpha = 0
        addTaskView.center = CGPoint(x: view.frame.midX, y: view.frame.maxY)
        
        UIView.animate(withDuration: 0.4) {
            [weak self]
            ()
            in
            self?.addTaskView.alpha = 1
            self?.addTaskView.center = (self?.view.center)!
        }
        
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        print(segmentedControl.selectedSegmentIndex)
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do{
            try taskList = context.fetch(request)
            self.taskTable.reloadData()
        }catch{
            print("Error while fetching.")
        }
        switch segmentedControl.selectedSegmentIndex{
        case 0: break
        case 1:
            taskList = taskList.filter({ (t) -> Bool in
                return t.status
            })
            break
        case 2:
            taskList = taskList.filter({ (t) -> Bool in
                return !t.status
            })
            break
        default: break
        }
        taskTable.reloadData()
    }
   
    @IBAction func addTask(_ sender: Any) {
        
        
        
        print(addTaskField.text!)
        let context = AppDelegate.viewContext
        let t = Task(context: context)
        t.name = addTaskField.text
        
        do{
            try context.save()
            print("Saved in db.")
            taskList.append(t)

        }catch{
            print("Error while saving in db.")
        }
        self.taskTable.reloadData()
        self.addTaskField.text = ""
        self.addTaskView.removeFromSuperview()
        self.visualBlur.removeFromSuperview()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.addTaskView.removeFromSuperview()
        self.visualBlur.removeFromSuperview()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task_cell") as! TaskTableViewCell
        cell.taskName.text = taskList[indexPath.row].name
        cell.status.isOn = !taskList[indexPath.row].status
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = AppDelegate.viewContext

        if editingStyle == UITableViewCellEditingStyle.delete{
            context.delete(taskList[indexPath.row])
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    func refresh(){
        print("Refreshing")
        self.taskTable.reloadData()
    }
    
    func changed(withName name: String){
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", name)
        request.predicate = predicate
        
        let t = try? context.fetch(request)
        t?[0].status = !(t?[0].status)!
        try? context.save()
    }
}

