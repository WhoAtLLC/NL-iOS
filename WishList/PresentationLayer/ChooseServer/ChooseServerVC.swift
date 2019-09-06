//
//  ChooseServerVC.swift
//  WishList
//
//  Created by RootMacBookPro on 25/06/19.
//  Copyright © 2019 Harendra Singh. All rights reserved.
//

import UIKit


class ChooseServerCell : UITableViewCell{
    
    @IBOutlet weak var lblServerName: UILabel!
    @IBOutlet weak var imgRadio: UIImageView!
    @IBOutlet weak var lblHost: UILabel!
}

class ChooseServerVC: UIViewController {
    
    @IBOutlet weak var tblServers: UITableView!
    
    var arrData = [[String: Any]]()
    let userDefauld = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblServers.delegate = self
        tblServers.dataSource = self
        
        tblServers.tableFooterView = UIView()
        
        arrData = userDefauld.value(forKey: AVAILABLE_HOST) as! [[String: Any]]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(netHex: 0xF9F9F9)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var userInput: UITextField?

    
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.userInput = textField!        //Save reference to the UITextField
            self.userInput?.placeholder = "Some text";
        }
    }
    func openAlertView() {
        let alert = UIAlertController(title: "NiceLeads", message: "Please add Host Url", preferredStyle: .alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in

            if self.userInput?.text! != ""{
                var dict = ["Server":"Dev \(self.arrData.count + 1)",
                            "HostUrl": self.userInput?.text!,
                            "selected":false] as [String : Any]
                
                self.arrData.append(dict)
                self.userDefauld.set(self.arrData, forKey: AVAILABLE_HOST)
            }
            self.tblServers.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
       
        openAlertView()
    }
}

extension ChooseServerVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var server = arrData[indexPath.row]
        let cell = tblServers.dequeueReusableCell(withIdentifier: "ChooseServerCell") as! ChooseServerCell
        cell.lblHost.text = server["HostUrl"] as! String
        
        if  server["Server"] as! String != "" && server["Server"] as! String != nil {
            cell.lblServerName.text = server["Server"] as! String
        }
        
        let isSelected = server["selected"] as! Bool
        
        if isSelected{
            
            cell.imgRadio.image = UIImage(named: "radio")
            
        }else{
            
            cell.imgRadio.image = UIImage(named: "radioUnselect")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for i in 0..<arrData.count {
            var server = arrData[i]
            server.updateValue(false, forKey: "selected")
            arrData[i] = server
        }
        
        var server = arrData[indexPath.row]

        let isSelected = server["selected"] as! Bool

        if isSelected{
           server.updateValue(false, forKey: "selected")
            arrData[indexPath.row] = server
        }else{
          server.updateValue(true, forKey: "selected")
            arrData[indexPath.row] = server
            userDefauld.set(server, forKey: SELECTED_HOST)
        }
        userDefauld.set(arrData, forKey: AVAILABLE_HOST)
        tblServers.reloadData()
    }
}
