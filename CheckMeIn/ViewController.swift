//
//  ViewController.swift
//  CheckMeIn
//
//  Created by Mitchell Sweet on 6/5/17.
//  Copyright © 2017 Mitchell Sweet. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var clearButton: UIBarButtonItem!
    
    var namesArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFromDefaults()
        viewSetup()
        tableViewSetup()
        
    }
    
    func viewSetup() {
        title = "CheckMeIn"
        addButton.tintColor = UIColor.white
        clearButton.tintColor = UIColor.white
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1882352941, green: 0.8235294118, blue: 0.5176470588, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    
    @IBAction func addAttendee() {
        
        let addAlert = UIAlertController(title: "New Attendee", message: "Add attendee information.", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            if let field = addAlert.textFields?[0] {
                self.saveToList(memberName: field.text!)
            } else {
                print("Name field was empty.")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        addAlert.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.autocapitalizationType = .words
            textField.returnKeyType = .done
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
        }
        
        addAlert.addAction(saveAction)
        addAlert.addAction(cancelAction)
        
        self.present(addAlert, animated: true, completion: nil)
    }
    
    
    func saveToList(memberName: String) {
        namesArray.append(memberName)
        let newIndex = IndexPath(row: namesArray.count - 1, section: 0)
        tableView.insertRows(at: [newIndex], with: .automatic)
        setToDefaults()
        print(namesArray.description)
    }
    
    
    func getFromDefaults() {
        
        if let names = UserDefaults.standard.array(forKey: "savedNames") {
            namesArray = names as! [String]
        }
        else {
            setToDefaults()
            print("Array did not exist, saving empty array.")
        }
    }
    
    func setToDefaults() {
        UserDefaults.standard.set(namesArray, forKey: "savedNames")
        
    }
    
    @IBAction func clearButtonTapped() {
        
        guard namesArray.count != 0 else {
            return
        }
        
        let clearAlert = UIAlertController(title: "Clear All", message: "Are you sure you want to delete all attendees? You cannot undo this action.", preferredStyle: .alert)
            
        let clearAction = UIAlertAction(title: "Clear", style: UIAlertActionStyle.destructive, handler:{ (UIAlertAction)in
            self.clearAll()
        })
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
        clearAlert.addAction(clearAction)
        clearAlert.addAction(cancelAction)
            
        self.present(clearAlert, animated: true, completion: nil)
    }
    
    func clearAll() {
        namesArray.removeAll()
        setToDefaults()
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        print("All items cleared. \(namesArray.description)")
    }
    
    func tableViewSetup() {
        tableView.rowHeight = 60
        tableView.separatorColor = #colorLiteral(red: 0.1880986989, green: 0.8226090074, blue: 0.5176928043, alpha: 1)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell",
                                                     for: indexPath)
        
        cell.textLabel?.text = self.namesArray[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            namesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            setToDefaults()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

