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
        case Amperage           = "Amperage"
        case CurrentCapacity    = "CurrentCapacity"
        //Add cycle count later
        case DesignCapacity     = "DesignCapacity"
        //Add cycle count and fully charged indicators later
        case CycleCount         = "CycleCount"
        case IsCharging         = "IsCharging"
        case MaxCapacity        = "MaxCapacity"
        case Temperature        = "Temperature"
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
    public func getBatteryDetailedInfo() -> [[String: String]]{
        let currentCharge: String =  String(currentCapacity()) + "mA h";
        let maxCharge: String = String(maxCapacity()) + "mA h";
        let designCharge: String = String(designCapacity()) + "mA h";
        let currentCycleCount: String = String(cycleCount());
        let currentAmperage: String = String(amperage()) + "Amps";
        let currentTemperature: String =  String(temperature()) + "°C";
        let charging = isCharging();
        if charging {
            let info = [
                        ["propertyName":"Current Charge",
                         "value":currentCharge],
                        ["propertyName":"Maximum Charge",
                         "value":maxCharge],
                        ["propertyName":"Design Capacity",
                         "value":designCharge],
                        ["propertyName":"Cycle Count",
                         "value":currentCycleCount],
                        ["propertyName":"Charging With",
                         "value": currentAmperage],
                        ["propertyName":"Tempertature",
                         "value":currentTemperature]
            ] as [[String:String]];
            return info;
        }
        let info = [
                    ["propertyName":"Current Charge",
                     "value":currentCharge],
                    ["propertyName":"Maximum Charge",
                     "value":maxCharge],
                    ["propertyName":"Design Capacity",
                     "value":designCharge],
                    ["propertyName":"Cycle Count",
                     "value":currentCycleCount],
                    ["propertyName":"Discharging With",
                     "value":currentAmperage],
                    ["propertyName":"Tempertature",
                     "value":currentTemperature]
        ] as [[String:String]];
        return info;
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
    
    private func cycleCount() -> Int{
        let retVal = IORegistryEntryCreateCFProperty(service, Key.CycleCount.rawValue as CFString, kCFAllocatorDefault, 0);
        return retVal?.takeUnretainedValue() as! Int;
        
    }
    private func amperage() -> Int{
        let retVal = IORegistryEntryCreateCFProperty(service, Key.Amperage.rawValue as CFString, kCFAllocatorDefault, 0);
        return retVal?.takeUnretainedValue() as! Int;
    }
    private func temperature() -> Double{
        let retVal = IORegistryEntryCreateCFProperty(service, Key.Temperature.rawValue as CFString, kCFAllocatorDefault, 0);
        let temp = retVal?.takeUnretainedValue() as! Double / 100;
        return ceil(temp);
    }
    
    
}
