//
//  InternalBattery.swift
//  batstat
//
//  Created by Benjamin Solomons on 29/01/2021.
//  Copyright © 2021 Benjamin Solomons. All rights reserved.
//

import Foundation
import IOKit

public struct InternalBattery{
    
    //Add temperature enum later
    
    //Battery property Keys, currently only ones that will be used.
    fileprivate enum Key: String {
        case ACPowered          = "ExternalConnected"
        case Amperage           = "Amperage"
        case CurrentCapacity    = "CurrentCapacity"
        //Add cycle count later
        case DesignCapacity     = "DesignCapacity"
        //Add cycle count and fully charged indicators later
        case IsCharging         = "IsCharging"
        case MaxCapacity        = "MaxCapacity"
        //add temperature later
        case TimeRemaining      = "TimeRemaining"
    }
    
    fileprivate static let IOSERVICE_BATTERY = "AppleSmartBattery";
    fileprivate var service: io_service_t = 0;
    
    public init(){}
    //Open connection to battery
    
    public mutating func open() -> kern_return_t{
        if service != 0{
            return kIOReturnStillOpen
        }
        
        service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceNameMatching(InternalBattery.IOSERVICE_BATTERY));
        if service == 0{
            return kIOReturnNotFound;
        }
        return kIOReturnSuccess;
    }
    
    public mutating func close()-> kern_return_t{
        let result = IOObjectRelease(service);
        service = 0;
        return result
    }
    //return basic values all at once.
    public func getPopoverBatteryInfo() -> (timeRemaining: String, batteryLevelPerc: Double, batteryDesCapPerc: Double){
        let timeLeft = timeRemaining();
        let currentCharge = currentCapacity();
        let maxCharge = maxCapacity();
        let designCharge = designCapacity();
        let batteryLevel = round((Double(currentCharge) / Double(maxCharge))*1000)/10;
        let batteryHealth = round((Double(maxCharge)/Double(designCharge))*1000)/10;
        return (timeLeft, batteryLevel, batteryHealth);
        
        
    }
    
    //Provides time remaining as a formatted string in format Hours:Minutes
    public func timeRemaining() -> String{
        let time = timeRemainingRaw();
        return NSString(format: "%d:%02d", time / 60, time%60) as String
    }
    //Use to update the colour of the battery level indicator
    public func isCharging() -> Bool{
        let retVal = IORegistryEntryCreateCFProperty(service, Key.IsCharging.rawValue as CFString!, kCFAllocatorDefault, 0);
        return retVal!.takeUnretainedValue() as! Bool;
    }
    
    private func currentCapacity()-> Int{
        let retVal = IORegistryEntryCreateCFProperty(service, Key.CurrentCapacity.rawValue as CFString!, kCFAllocatorDefault, 0);
        return retVal!.takeUnretainedValue() as! Int;
    }
    
    private func maxCapacity() -> Int{
        let retVal = IORegistryEntryCreateCFProperty(service, Key.MaxCapacity.rawValue as CFString!, kCFAllocatorDefault, 0);
        return retVal!.takeUnretainedValue() as! Int;
    }
    private func designCapacity() -> Int {
        let retVal = IORegistryEntryCreateCFProperty(service, Key.DesignCapacity.rawValue as CFString!,kCFAllocatorDefault , 0);
        return retVal!.takeUnretainedValue() as! Int;
    }
    
    private func timeRemainingRaw() -> Int{
        let retVal = IORegistryEntryCreateCFProperty(service, Key.TimeRemaining.rawValue as CFString!, kCFAllocatorDefault, 0);
        return retVal!.takeUnretainedValue() as! Int;
    }
    
}
