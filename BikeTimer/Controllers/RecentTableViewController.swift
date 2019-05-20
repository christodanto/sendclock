//
//  RecentTableViewController.swift
//  BikeTimer
//
//  Created by Andrew Burns on 10/18/18.
//  Copyright © 2018 Andrew Burns. All rights reserved.
//

import UIKit
import Firebase

class RecentTableViewController: UITableViewController {
    var times:[Double] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        observeTimes()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func clear(_ sender: Any) {
       let ref = Database.database().reference().child("timers")
        ref.removeValue()
        self.times = []
        self.tableView.reloadData()
    }
    
    func observeTimes() {
        let ref = Database.database().reference().child("timers")
        ref.observe(.childAdded) { (snapshot) in
            if let data = snapshot.value as? [String:Double] {
                if data["end_time"] != nil {
                    self.times.append(data["end_time"]! - data["start_time"]!)
                    self.times.reverse()
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return times.count
    }

    func timerValue(time:Double) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let x = time.truncatingRemainder(dividingBy: 1)
        let milliseconds = Int(x * 100)
        return String(format:"%02i:%02i.%02i", minutes, seconds,milliseconds)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "time_cell", for: indexPath) as! TimeTableViewCell
        cell.timeLabel.text = timerValue(time: (times[indexPath.row]))
        // Configure the cell...

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
