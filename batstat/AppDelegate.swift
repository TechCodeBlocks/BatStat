//
//  AppDelegate.swift
//  batstat
//
//  Created by Benjamin Solomons on 27/01/2021.
//  Copyright © 2021 Benjamin Solomons. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let statusItem2 = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
   
    let popover = NSPopover();
    var eventMonitor: EventMonitor?;
    var timer: Timer!;
    var battery: InternalBattery!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //Check if application is on first launch, if so write dummy data
        //Also write to UserDefaults to set a flag to stop this running every time
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if(!launchedBefore){
            
            BatHistoryManager.initStorage();
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        //Create the main status bar item that will open the pop-over
        if let button = statusItem.button{
            button.image = NSImage(named: NSImage.Name("bat"));
            button.action = #selector(togglePopover(_:));
            
        }
        //Create the second status bar item that will show the time remaining
        if let text = statusItem2.button{
            text.title = "Number";
        }
        //Set up the pop-over and event monitor to check for clicks outside of the window. Starts timer to refresh battery info.
        popover.contentViewController = BatteryViewController.freshController()
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: {[weak self] event in if let strongSelf = self, strongSelf.popover.isShown{
            strongSelf.closePopover(sender: event)
            }})
        startTimer();
        // Insert code here to initialize your application
    }
    

    func applicationWillTerminate(_ aNotification: Notification) {
        stopTimer();
    }
    //Refreshes the text showing the time remaining every 5 seconds
    @objc func updateRemainingText(){
        var battery = InternalBattery();
        battery.open();
        let timeRemaining = battery.timeRemaining();
        if let text = statusItem2.button{
            text.title = timeRemaining;
        }
        battery.close();
    }
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateRemainingText), userInfo: nil, repeats: true);
        timer?.fire()
        RunLoop.current.add(timer!, forMode: .common)
        
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    @objc func togglePopover(_ sender: Any?){
        if popover.isShown{
            closePopover(sender: sender);
        }else{
            showPopover(sender: sender)
        }
    }
    func showPopover(sender: Any?){
        if let button = statusItem.button{
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY);
        }
        eventMonitor?.start();
    }
    
    func closePopover(sender: Any?){
        popover.performClose(sender);
        eventMonitor?.stop();
    }

}



