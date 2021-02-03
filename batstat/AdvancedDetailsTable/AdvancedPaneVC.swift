//
//  AdvancedPaneVC.swift
//  batstat
//
//  Created by Benjamin Solomons on 03/02/2021.
//  Copyright © 2021 Benjamin Solomons. All rights reserved.
//

import Cocoa

class AdvancedPaneVC: NSViewController {
    @IBOutlet weak var tableView: NSTableView!;
    var batteryItems = [[String:String]]();
    
    

    override func viewDidLoad() {
        tableView.delegate = self;
        tableView.dataSource = self;
        
        
        super.viewDidLoad()
        // Do view setup here.
    }
    override func viewWillAppear(){
        var battery = InternalBattery();
        battery.open();
        batteryItems = battery.getBatteryDetailedInfo();
        battery.close();
        super.viewWillAppear();
        tableView.reloadData();
    }
    
}

extension AdvancedPaneVC: NSTableViewDataSource{
    func numberOfRows(in tableView: NSTableView )-> Int{
        return batteryItems.count;
    }
}
extension AdvancedPaneVC: NSTableViewDelegate{
    fileprivate enum CellIdentifiers{
        static let PropertyCell = "PropertyCellID"
        static let ValueCell = "ValueCellID"
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        var text: String = "";
        var cellIdentifier = "";
        let item = batteryItems[row]
        if item == nil{
            return nil;
        }
        
        if tableColumn == tableView.tableColumns[0]{
            text = item["propertyName"] as! String;
            
            cellIdentifier = CellIdentifiers.PropertyCell
        } else if tableColumn == tableView.tableColumns[1]{
            text = item["value"] as! String;
            cellIdentifier = CellIdentifiers.ValueCell
            
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: self) as? NSTableCellView{
            cell.textField?.stringValue = text;
            return cell;
        }
        print("error, unable to make View for some reason")
        return nil;
        
            
            
                    
    }
    
}

