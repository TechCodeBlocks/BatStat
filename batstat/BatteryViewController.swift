//
//  BatteryViewControlller.swift
//  batstat
//
//  Created by Benjamin Solomons on 29/01/2021.
//  Copyright © 2021 Benjamin Solomons. All rights reserved.
//

import Cocoa

class BatteryViewController: NSViewController {
    
    @IBOutlet weak var timeRemainingLabel: NSTextField!;
    @IBOutlet weak var batteryLevelLabel: NSTextField!;
    @IBOutlet weak var designCapacityLevel: NSTextField!;
    @IBOutlet weak var batterylevelIndicator: NSLevelIndicator!;
    @IBOutlet weak var designCapacityIndicator: NSLevelIndicator!;
    @IBOutlet weak var addHistory: NSButton!;
    
    var timer: Timer!;
    var battery: InternalBattery!;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    override func viewWillAppear() {
        battery = InternalBattery();
        battery.open()
        startTimer();
    }
    override func viewDidDisappear() {
        stopTimer();
        battery.close();
    }
    /* Add a new reading to the info history.
        - Reads in existing values
        - Appends the new values to the existing list
        - Writes the new list to the file*/
    @IBAction func storeDataButtonClicked(_ sender: NSButton){
        var existingData = BatHistoryManager.getStoredBatteryInfo();
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let dateString = formatter1.string(from: today);
        let maxCharge = battery.getBatteryDetailedInfo()[1]["value"] as! String;
        existingData.append(["Date":dateString,"Capacity":maxCharge]);
        BatHistoryManager.storeBatteryInfo(data: existingData);
        
        
        
    }
    //Will run on a timer every 2 seconds
    @objc fileprivate func showBatteryInfo(){
        let batteryInfo = battery.getPopoverBatteryInfo();
        let isCharging = battery.isCharging();
        //Add UI nicities for charging/discharging
        if(isCharging){
            timeRemainingLabel.stringValue = "Time Until Charged: \(batteryInfo.timeRemaining)";
            batterylevelIndicator.fillColor = NSColor.orange
        }else{
            batterylevelIndicator.fillColor = NSColor.green
            timeRemainingLabel.stringValue = "Time Remaining: \(batteryInfo.timeRemaining)";
        }
        batterylevelIndicator.doubleValue = batteryInfo.batteryLevelPerc;
        designCapacityIndicator.doubleValue = batteryInfo.batteryDesCapPerc;
        batteryLevelLabel.stringValue = "Current Charge: \(batteryInfo.batteryLevelPerc)%";
        designCapacityLevel.stringValue = "Battery Health: \(batteryInfo.batteryDesCapPerc)%";
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(showBatteryInfo), userInfo: nil, repeats: true);
        timer?.fire()
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
}
extension BatteryViewController{
    
    static func freshController() -> BatteryViewController{
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil);
        let identifier = NSStoryboard.SceneIdentifier("BatteryViewController");
        guard let viewController = storyboard.instantiateController(withIdentifier: identifier) as? BatteryViewController else {
            fatalError("Why can't I find BatteryViewController - Check Main.Storyboard");
        }
        
        return viewController
    }
}
