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
        batteryItems = [["propertyName":"Test", "value":"testing"], ["propertyName":"CycleCount", "value":"100"]]
        print("pane loaded")
        super.viewDidLoad()
        // Do view setup here.
    }
    override func viewWillAppear(){
        super.viewWillAppear();
        tableView.reloadData();
    }
    
}
extension AdvancedPaneVC{
    
    static func freshController() -> AdvancedPaneVC{
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil);
        let identifier = NSStoryboard.SceneIdentifier("AdvancedPaneVC");
        guard let viewController = storyboard.instantiateController(withIdentifier: identifier) as? AdvancedPaneVC else {
            fatalError("Why can't I find AdvancedPaneVC - Check Main.Storyboard");
        }
        
        print("loaded vc")
        return viewController
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
            print("Column0")
            cellIdentifier = CellIdentifiers.PropertyCell
        } else if tableColumn == tableView.tableColumns[1]{
            text = item["value"] as! String;
            cellIdentifier = CellIdentifiers.ValueCell
            print("Column1")
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: self) as? NSTableCellView{
            print(text)
            cell.textField?.stringValue = text;
            return cell;
        }
        print("error, unable to make View for some reason")
        return nil;
        
            
            
                    
    }
    
}

