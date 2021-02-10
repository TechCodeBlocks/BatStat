//
//  BatHistoryManager.swift
//  batstat
//
//  Created by Benjamin Solomons on 06/02/2021.
//  Copyright © 2021 Benjamin Solomons. All rights reserved.
//

import Foundation

class BatHistoryManager{
    /*Will run only on the first time that the app opens on a users
     laptop. Initialises the data-store with a piece of dummy data.
     This is needed as if they open the battery history view before adding
     a new item and the storage hasn't been initiated an error will occur
     and the  app will hang*/
    static func initStorage(){
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("DesCapHistory");
        let initData = [["Date":"1/1/71","Capacity":"FULL"]]
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: initData)
            try data.write(to: path);
            
        }catch{
            print("error writing initiating data");
        }
        
    }
    /* Loads the data that has been written to the device and returns it.
     Data is in the format of a list of dictionaries.
     Each dictionary contains a date and a capacity in milli-amp hours*/
    static func getStoredBatteryInfo()-> [[String:String]]{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("DesCapHistory");
        do{
            let data = try Data(contentsOf: path);
            if let historyItems = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [[String:String]]{
            return historyItems;
            }
        
        } catch{
            print("Error getting data");
        }
        return [["Error":"Error"]];
    }
    /* Writes the data to the document containing historical information*/
    
    static func storeBatteryInfo(data: [[String:String]]){
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("DesCapHistory");
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: data);
            try data.write(to: path);
        }catch{
            print("error writing data");
        }
    }
}
