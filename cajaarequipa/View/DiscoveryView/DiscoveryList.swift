//
//  DiscoveryList.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 4/1/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
protocol DiscoveryListDelegate {
    
}
class DiscoveryList: UIView, UITableViewDelegate, UITableViewDataSource {

    var delegate: DiscoveryList?
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var tableView: UITableView!
    var currentData:[User] = []
    
    func drawBody(barHeight:CGFloat){
        self.tableView = UITableView(frame: CGRect(x:  (self.frame.size.width-293*valuePro)/2, y: 85*valuePro, width:293*valuePro, height: self.frame.size.height-114))
        self.tableView.backgroundColor = UIColor.init(hexString: "ffffff")
        self.tableView.separatorColor = UIColor.clear
        
        self.tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addSubview(self.tableView)
    }
    // MARK: - TableView Datasource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //  let sectionInfo = self.fetchedResultsController.sections![section]
        return currentData.count//sectionInfo.numberOfObjects
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    public func tableView(_ tableView:         UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        cell.loadWithUser(user: currentData[indexPath.row])
        return cell
    }
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
        return 92*valuePro;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do here
//        let cause:EntityCause = currentData.object(at: indexPath.row) as! EntityCause//self.fetchedResultsController.object(at: indexPath)
//        let causeDetailVC:DetailCauseViewController = DetailCauseViewController()
//        causeDetailVC.uid = cause.id
//        if currentType == 1 && self.isExplorerSession == false {
//            causeDetailVC.isExplorerSession = false
//        }
//        self.navigationController?.pushViewController(causeDetailVC, animated: true)
    }

}
