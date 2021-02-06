//
//  DesignCapacityHistoryContainer.swift
//  batstat
//
//  Created by Benjamin Solomons on 06/02/2021.
//  Copyright © 2021 Benjamin Solomons. All rights reserved.
//

import Cocoa

class DesignCapacityHistoryContainer: NSObject, NSCoding {
    var historyItems = [[String:String]]();
    init(items: [[String:String]]){
        historyItems = items;
        
    }
    func encode(with coder: NSCoder) {
        coder.encode(self.historyItems, forKey: "historyItems")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let items = decoder.decodeObject(forKey: "historyItems") as? [[String:String]] else{return nil}
        self.init(items: items);
        
    }
    
    

}
