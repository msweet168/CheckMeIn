//
//  ViewController.swift
//  CheckMeIn
//
//  Created by Mitchell Sweet on 6/5/17.
//  Copyright © 2017 Mitchell Sweet. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    //Outlets for main view.
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var clearButton: UIBarButtonItem!
    
    //variable namesArray stores an array of Attendee structs.
    var namesArray = [Attendee]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up view by getting the saved array from userdefaults and setting it, setting up the navigation controller, and setting up the tableview.
        getFromDefaults()
        viewSetup()
        tableViewSetup()
        
    }
    
    ///Sets up the look and feel of the UI.
    func viewSetup() {
        title = "CheckMeIn"
        addButton.tintColor = UIColor.white
        clearButton.tintColor = UIColor.white
        
        //Sets the bar style to black so the bold title changes to a white color.
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        //then sets the bar to the app's theme color,
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1882352941, green: 0.8235294118, blue: 0.5176470588, alpha: 1)
        //and sets the text color of the nav bar to white.
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    //Connected to + button, addAttendee creates an alert view with textfields that allows the user to add a new attendee.
    @IBAction func addAttendee() {
        //Create the alert
        let addAlert = UIAlertController(title: "New Attendee", message: "Add attendee information.", preferredStyle: .alert)
        
        //Create the save action
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            //if the text field exists and is not empty...
            if let field = addAlert.textFields?[0] {
                //call save to list with the name entered in the view
                //TODO: once other textfields are made, pass those values into saveToList.
                self.saveToList(memberName: field.text!)
            } else {
                print("Name field was empty.")
            }
        })
        
        //Create the cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //Add textfields
        //TODO: add more textfields for the other properties of an attendee.
        addAlert.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.autocapitalizationType = .words
            textField.returnKeyType = .done
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
        }
        
        //Add actions to alert
        addAlert.addAction(saveAction)
        addAlert.addAction(cancelAction)
        
        //Present alert
        self.present(addAlert, animated: true, completion: nil)
    }
    
    //saveToList adds an attendee to the namesArray. All attributes of an attendee are passed into it.
    //TODO: Add more parameters for other attributes of attendee.
    func saveToList(memberName: String) {
        
        //Create an Attendee.
        //TODO: Lastname, description, and date currently have placeholders.
        let lastMember = Attendee(firstName: memberName, lastName: "foo", description: "bar", date: Date())
        
        //Append the attendee to the array
        namesArray.append(lastMember)
        //Create a new index to and insert it into the table view.
        let newIndex = IndexPath(row: namesArray.count - 1, section: 0)
        tableView.insertRows(at: [newIndex], with: .automatic)
        //Save the new array to userdefaults.
        setToDefaults()
    }
    
    //When called, getFromDefauts retreives and decodes the saved array from userdefaults and sets savedNames to it.
    func getFromDefaults() {
        
        //Checks to make sure an array exists, if it does nit, it sets an empty array to the defualts.
        if let encodedNames = UserDefaults.standard.data(forKey: "savedNames") {
            //create a decoder
            let decoder = JSONDecoder()
            
            do {
                //Decode the array and set it to namesArray.
                let decodedArray = try decoder.decode([Attendee].self, from: encodedNames)
                namesArray = decodedArray 
            }
            catch {
                fatalError("Could not retreive array from userdefaults.")
            }
            
        }
        else {
            setToDefaults()
            print("Array did not exist, saving empty array.")
        }
    }
    
    //When called, setToDefaults encodes the current namesArray and saves it to userdefaults.
    func setToDefaults() {
        //Create an encoder.
        let encoder = JSONEncoder()
        
        do {
            //Encode the array and save it to userdefaults.
            let encodedNamesArray = try encoder.encode(namesArray)
            UserDefaults.standard.set(encodedNamesArray, forKey: "savedNames")
        }
        catch {
            fatalError("Cannot encode array")
        }
        
    }
    
    //Connected to the clear button, clearButtonTapped shows an alert which will ensure the user wants to clear all entries.
    @IBAction func clearButtonTapped() {
        
        //Guard to check if array is empty. If array is empty, nothing will happen since there is nothing to clear.
        guard namesArray.count != 0 else {
            print("The array is empty, nothing to clear.")
            return
        }
        
        //Create the alert.
        let clearAlert = UIAlertController(title: "Clear All", message: "Are you sure you want to delete all attendees? You cannot undo this action.", preferredStyle: .alert)
        
        //Create the clear action.
        let clearAction = UIAlertAction(title: "Clear", style: UIAlertActionStyle.destructive, handler:{ (UIAlertAction)in
            self.clearAll()
        })
        
        //Create the cancel action.
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //Add actions to the alert.
        clearAlert.addAction(clearAction)
        clearAlert.addAction(cancelAction)
        
        //Present the alert.
        self.present(clearAlert, animated: true, completion: nil)
    }
    
    //When called, the clearAll function will remove all Attendee objects inside the namesArray and update the defaults and tableview.
    func clearAll() {
        //Clear the array.
        namesArray.removeAll()
        //Update userdefaults.
        setToDefaults()
        //Clear the tableview.
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        //Print confirmation.
        print("All items cleared. \(namesArray.description)")
    }
    
    //Sets up basic settings for the table view.
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
        
        cell.textLabel?.text = self.namesArray[indexPath.row].firstName
        cell.detailTextLabel?.text = self.namesArray[indexPath.row].description
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

