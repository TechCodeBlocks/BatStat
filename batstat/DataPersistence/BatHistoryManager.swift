//
//  BatHistoryManager.swift
//  batstat
//
//  Created by Benjamin Solomons on 06/02/2021.
//  Copyright © 2021 Benjamin Solomons. All rights reserved.
//

import Foundation

class BatHistoryManager{
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
