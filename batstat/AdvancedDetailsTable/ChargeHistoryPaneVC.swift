//
//  ChargeHistoryPaneVC.swift
//  batstat
//
//  Created by Benjamin Solomons on 09/02/2021.
//  Copyright © 2021 Benjamin Solomons. All rights reserved.
//

import Cocoa

class ChargeHistoryPaneVC: NSViewController {
    @IBOutlet weak var tableView: NSTableView!;
    var chargeHistory = [[String:String]]()

    override func viewDidLoad() {
        tableView.delegate = self;
        tableView.dataSource = self;
        super.viewDidLoad()
        // Do view setup here.
    }
    override func viewWillAppear() {
        chargeHistory = BatHistoryManager.getStoredBatteryInfo();
        chargeHistory.remove(at: 0);
        print(chargeHistory)
        tableView.reloadData();
        super.viewWillAppear();
        
        
    }
    
}
extension ChargeHistoryPaneVC: NSTableViewDataSource{
    func numberOfRows(in tableView: NSTableView )-> Int{
        return chargeHistory.count;
    }
}
extension ChargeHistoryPaneVC: NSTableViewDelegate{
    fileprivate enum CellIdentifiers{
        static let DateCell = "DateID"
        static let CapCell = "MaxCapID"
    }
     func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        var text: String = "";
        var cellIdentifier = "";
        let item = chargeHistory[row]
        
        print(item)
        if item == nil{
            return nil;
        }
        
        if tableColumn == tableView.tableColumns[0]{
            text = item["Date"] as! String;
            
            cellIdentifier = CellIdentifiers.DateCell
        } else if tableColumn == tableView.tableColumns[1]{
            text = item["Capacity"] as! String;
            cellIdentifier = CellIdentifiers.CapCell
            
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: self) as? NSTableCellView{
            cell.textField?.stringValue = text;
            return cell;
        }
        print("error, unable to make View for some reason")
        return nil;
        
        
        
        
    }
    
}

