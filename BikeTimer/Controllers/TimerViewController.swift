//
//  TimerViewController.swift
//  BikeTimer
//
//  Created by Andrew Burns on 10/18/18.
//  Copyright © 2018 Andrew Burns. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class TimerViewController: UIViewController {
    
    var player: AVAudioPlayer?
    weak var timer: Timer?
    var time: Double = 0
    var startTime:Double = 0
    var race:[String:Any]?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    var currentTimerId:String? {
        didSet {
            print("DID SET TIMER ID")
            if currentTimerId != "" {
                let ref2 = Database.database().reference().child("timers").child(self.currentTimerId!)
                ref2.observe(.value) { (snapshot) in
                    if let data = snapshot.value as? [String:Any] {
                        if data["end_time"] != nil {
                            self.stopTimer()
                        }
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Race: ", race)
        currentTimerId = ""
        drawViews()
//        findCurrentTimer()
        resetButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    func drawViews() {
        startButton.backgroundColor = hexStringToUIColor(hex: "#d4ebf2")
        startButton.layer.cornerRadius = startButton.frame.width / 2
        stopButton.backgroundColor = hexStringToUIColor(hex: "#d4ebf2")
        stopButton.layer.cornerRadius = startButton.frame.width / 2
        resetButton.backgroundColor = hexStringToUIColor(hex: "#d4ebf2")
        resetButton.layer.cornerRadius = startButton.frame.width / 2
    }
    
    func findCurrentTimer() {
        let ref = Database.database().reference().child("timers")
        let query = ref.queryOrdered(byChild: "end_time").queryEqual(toValue: nil)
        query.observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String:[String:Any]] {
                self.currentTimerId = (data.first?.key)!
                self.startTime = data.first!.value["start_time"] as! Double
                self.startTimer(start_time: data.first!.value["start_time"] as! Double)
                
            }
        }
        query.observe(.childAdded) { (snapshot) in
            if self.timer == nil || self.timer?.isValid == false {
                if let data = snapshot.value as? [String:Any] {
                    self.currentTimerId = snapshot.key
                    self.startTime = data["start_time"] as! Double
                    self.startTimer(start_time: data["start_time"] as! Double)
                }
            }
        }
    }
    
    
    @IBAction func start(_ sender: Any) {
        let now = Date().timeIntervalSinceReferenceDate
        startTime = now
        startTimer(start_time: now)
    }
    
    @IBAction func stop(_ sender: Any) {
        stopTimer()
    }
    
    @IBAction func reset(_ sender: Any) {
        resetTimer()
    }
    func startTimer(start_time: Double) {
        playSound()
        sleep(4)
        if currentTimerId == "" {
            let ref = Database.database().reference().child("timers").childByAutoId()
            let now = Date().timeIntervalSinceReferenceDate
            ref.setValue(["start_time" : now])
            
            print("REF: ", ref)
            currentTimerId =  ref.key!
            startTime = Date().timeIntervalSinceReferenceDate
            
        }
        timer = Timer.scheduledTimer(timeInterval: 0.01,
                                     target: self,
                                     selector: #selector(advanceTimer(timer:)),
                                     userInfo: nil,
                                     repeats: true)
        startButton.isEnabled = false
        stopButton.isEnabled = true
        resetButton.isEnabled = false
//        let ref2 = Database.database().reference().child("timers").child(self.currentTimerId!)
//        print("SETTING THIS REF")
//        print(self.currentTimerId)
//        ref2.observe(.childChanged) { (snapshot) in
//            print(self.currentTimerId)
//            print("CHANGED!")
//        }
    }
    func timerValue(time:Double) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let x = time.truncatingRemainder(dividingBy: 1)
        let milliseconds = Int(x * 100)
        return String(format:"%02i:%02i.%02i", minutes, seconds,milliseconds)
    }
    
    func stopTimer() {
        if currentTimerId != "" {
            let ref = Database.database().reference().child("timers").child(currentTimerId!)
            let now = Date().timeIntervalSinceReferenceDate
            ref.updateChildValues(["end_time": now ])
        }
        timer?.invalidate()
        startButton.isEnabled = false
        stopButton.isEnabled = false
        resetButton.isEnabled = true
        currentTimerId = ""
        
    }

    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "cart", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func resetTimer() {
        startButton.isEnabled = true
        stopButton.isEnabled = false
        resetButton.isEnabled = false
        currentTimerId = ""
        timeLabel.text = "00:00.00"
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    fileprivate func changeTime() {
        //Total time since timer started, in seconds
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        //The rest of your code goes here
        
        //Convert the time to a string with 2 decimal places
        //        let timeString = String(format: "%.2f", time as CVarArg)
        let timeString = timerValue(time: time)
        
        //Display the time string to a label in our view controller
        timeLabel.text = timeString
    }
    
    @objc func advanceTimer(timer: Timer) {
        changeTime()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
