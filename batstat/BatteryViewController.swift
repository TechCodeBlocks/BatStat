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
    
    @objc fileprivate func showBatteryInfo(){
        var batteryInfo = battery.getPopoverBatteryInfo();
        timeRemainingLabel.stringValue = "Time Remaining: \(batteryInfo.timeRemaining)";
        batterylevelIndicator.doubleValue = batteryInfo.batteryLevelPerc;
        designCapacityIndicator.doubleValue = batteryInfo.batteryDesCapPerc;
        batteryLevelLabel.stringValue = "Current Charge: \(batteryInfo.batteryLevelPerc)%";
        designCapacityLevel.stringValue = "Battery Health: \(batteryInfo.batteryDesCapPerc)%";
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(showBatteryInfo), userInfo: nil, repeats: true);
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
        
        print("loaded vc")
        return viewController
    }
}