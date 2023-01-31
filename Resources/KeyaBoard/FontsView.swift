//
//  FontsView.swift
//  CustomKeyBoard
//
//  Created by MacBook Pro Retina on 23/10/19.
//  Copyright © 2019 MacBook Pro Retina. All rights reserved.
//

import UIKit

protocol changeFont {
    func changeFont(name: NSString)
}


class FontsView: UIView,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    
    public var delegateForFont: changeFont?
    
    
    override func draw(_ rect: CGRect) {
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FontCell", bundle: nil), forCellReuseIdentifier: "FontCell")
        
        tableView.reloadData()
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fontArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let name = fontArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FontCell", for: indexPath) as! FontCell
        
        cell.lbl.text = (name as! String)
        cell.lbl.textAlignment = .center
        cell.lbl.font =  UIFont(name:name as! String, size: 24.0)
        cell.selectionStyle = .none
        return cell
        
        
        
        
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
      
         let name = fontArray[indexPath.row]
         delegateForFont?.changeFont(name: name as! NSString)

        
    }
}

