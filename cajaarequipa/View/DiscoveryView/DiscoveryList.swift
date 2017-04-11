//
//  DiscoveryList.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 4/1/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
protocol DiscoveryListDelegate {
     func checkFollowing(indexPath: IndexPath, user:User)
     func updateCheckFollowing(indexPath: IndexPath, user:User)
     func loadNewUsers(offset : Int,user:User)
}
class DiscoveryList: UIView, UITableViewDelegate, UITableViewDataSource {

    var delegate: DiscoveryListDelegate?
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var tableView: UITableView!
    var currentData:[User] = []
    
    var pageNumber = 1
 
    var isLoading = false
    
    func drawBody(barHeight:CGFloat){
        
        self.frame =  CGRect(x:  (screenSize.width-320*valuePro)/2, y: 58*valuePro, width:320*valuePro, height: screenSize.height-barHeight-58*valuePro)
        self.tableView = UITableView(frame: CGRect(x:  (screenSize.width-320*valuePro)/2, y: 0, width:320*valuePro, height: self.frame.size.height-10*valuePro))
        self.tableView.backgroundColor = UIColor.init(hexString: "ffffff")
        self.tableView.separatorColor = UIColor.clear
        
        self.tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addSubview(self.tableView)
        
    }
    // MARK: - TableView Datasource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
        return currentData.count
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        cell.loadWithUser(user: currentData[indexPath.row])
        delegate?.checkFollowing(indexPath: indexPath,user:currentData[indexPath.row])
        return cell
    }
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
        return 92*valuePro;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.updateCheckFollowing(indexPath: indexPath, user: currentData[indexPath.row])
    }
    // MARK: - Firebase
    func updateWithData(list:[User]){
      
        currentData = list
        tableView.reloadData()
       
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.currentData.count-1 && self.isLoading == false {
            self.isLoading = true
            //load new data (new 10 movies)
            pageNumber = pageNumber + 1
            self.delegate?.loadNewUsers(offset: pageNumber, user: currentData.last!)
        }
    }
   
    

}
