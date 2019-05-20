//
//  SelectRaceTableViewController.swift
//  BikeTimer
//
//  Created by Andrew Burns on 3/29/19.
//  Copyright © 2019 Andrew Burns. All rights reserved.
//

import UIKit
import Firebase

class SelectRaceTableViewController: UITableViewController {
    var races:[[String:Any]] = []
    @IBAction func toNewRace(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference().child("races")
        ref.observe(.value) { (snapshot) in
            if let data = snapshot.value as? [String:[String:Any]] {
                for race in data {
                    var newRace = race.value
                    newRace["key"] = race.key
                    self.races.append(newRace)
//                    races.append(race)
                }
            } else {
                // load nothing
            }
            self.tableView.reloadData()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return races.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var race = races[indexPath.row]
        cell.textLabel?.text = race["name"] as? String
//        cell.detailTextLabel?.text = "Test"
//        cell.addSubview(UILabel)
//        race["created"] as? String
        // Configure the cell...
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(55)
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toRace", sender: races[indexPath.row])
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRace" {
            let race = sender as! [String:Any]
            let viewController:TimerViewController = segue.destination as! TimerViewController
            viewController.race = race
            
//            viewController.song_types = "dance"
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
