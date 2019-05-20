//
//  NewRaceViewController.swift
//  BikeTimer
//
//  Created by Andrew Burns on 3/29/19.
//  Copyright © 2019 Andrew Burns. All rights reserved.
//

import UIKit
import Firebase

class NewRaceViewController: UIViewController {

    @IBOutlet weak var createButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    
    
    @IBAction func createRace(_ sender: Any) {
        let name = nameField.text!
        let ref = Database.database().reference().child("races").childByAutoId()
        let now = Date().timeIntervalSinceReferenceDate
        var race = ["created" : now, "name": name] as [String : Any]
        ref.setValue(race) { (err, ref) in
            race["key"] = ref.key
            self.performSegue(withIdentifier: "toRace", sender: race)
            // guard against err !!
        }
//        ref.setValue(["created" : now, "name": name])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
