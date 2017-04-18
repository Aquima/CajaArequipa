//
//  Comment.swift
//  cajaarequipa
//
//  Created by Nara on 4/14/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
protocol CommentListDelegate {
    func postComment(message:String)
}
class CommentList: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    var delegate:CommentListDelegate?
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
//    var contentTable:UIScrollView!
    var currentTexfield:UITextField = UITextField()
    var messageTextfield:UITextField = UITextField()
    var currentBarHeight:CGFloat!
    
    var tableView: UITableView!
    var currentData:[Comment] = []
    
    var pageNumber = 1
    
    var isLoading = false
    
    func drawBody(barHeight:CGFloat){
        currentBarHeight = barHeight
        self.frame = CGRect(x:  (screenSize.width-320*valuePro)/2, y: 58*valuePro, width:320*valuePro, height: screenSize.height-58*valuePro-barHeight)
        self.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        
        let customComment:UIView = UIView()
        customComment.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        customComment.frame = CGRect(x: 0, y: self.frame.height-44*valuePro, width: self.frame.size.width, height: 44*valuePro)
        customComment.layer.borderColor = UIColor.init(hexString: GlobalConstants.color.grayLight).cgColor
        customComment.layer.borderWidth = 0.5
        self.addSubview(customComment)
        
        messageTextfield.frame = CGRect(x: 0, y: 0, width: self.frame.size.width-100*valuePro, height: 44)
        messageTextfield.placeholder = "Agregar un comentario.."
        messageTextfield.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 14*valuePro)
        messageTextfield.textColor = UIColor.blue
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        messageTextfield.leftView = paddingView;
        messageTextfield.leftViewMode =  .always
        messageTextfield.autocapitalizationType = .sentences
        messageTextfield.autocorrectionType = .no
        messageTextfield.delegate = self
        
        let btnPost = UIButton()
        btnPost.frame = CGRect(x: self.frame.size.width-100*valuePro, y: 0, width: 100, height: 44)
        btnPost.setTitleColor(UIColor.init(hexString: GlobalConstants.color.blue), for: .normal)
        btnPost.setTitle("Publicar", for: .normal)
        btnPost.titleLabel?.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        btnPost.setTitleColor(UIColor.init(hexString: GlobalConstants.color.blue), for: .normal)
        customComment.addSubview(messageTextfield)
        customComment.addSubview(btnPost)
        btnPost.addTarget(self, action: #selector(postComment(sender:)), for: .touchUpInside)
        messageTextfield.inputAccessoryView = createInputAccessoryView()
        messageTextfield.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        self.createTable()
        
    }
    func createInputAccessoryView()->UIView{
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        customView.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        customView.layer.borderColor = UIColor.init(hexString: GlobalConstants.color.grayLight).cgColor
        customView.layer.borderWidth = 0.5
        
        currentTexfield = UITextField()
        currentTexfield.frame = CGRect(x: 0, y: 0, width: self.frame.size.width-100*valuePro, height: 44)
        currentTexfield.placeholder = "Agregar un comentario.."
        currentTexfield.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 14*valuePro)
        currentTexfield.textColor = UIColor.blue
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        currentTexfield.leftView = paddingView;
        currentTexfield.leftViewMode =  .always
        let btnPost = UIButton()
        btnPost.frame = CGRect(x: self.frame.size.width-100*valuePro, y: 0, width: 100, height: 44)
        btnPost.setTitle("Publicar", for: .normal)
        btnPost.titleLabel?.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        btnPost.setTitleColor(UIColor.init(hexString: GlobalConstants.color.blue), for: .normal)
        btnPost.addTarget(self, action: #selector(postComment(sender:)), for: .touchUpInside)
        customView.addSubview(currentTexfield)
        customView.addSubview(btnPost)
        currentTexfield.isEnabled = false
        return customView
        
    }
    func textFieldDidChange(textField:UITextField){
        currentTexfield.text = textField.text
    }
    func postComment(sender:UIButton){
        if self.currentTexfield.text?.isEmpty == false{
            delegate?.postComment(message: self.currentTexfield.text!)
        }
    }
    func resignFirstResponderList(){
       // self.tableView.scrollToRow(at: <#T##IndexPath#>, at: .top, animated: true)
        
        UIView.animate(withDuration: 0.3,animations: {
           self.tableView.frame = CGRect(x: 0, y: 0, width: 320*self.valuePro, height: self.frame.size.height-44*self.valuePro)
        }, completion: { _ in

        })
        self.messageTextfield.resignFirstResponder()
    }
    // MARK: - TableView
    func createTable(){
 
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320*valuePro, height: self.frame.size.height-44*valuePro))
        self.tableView.backgroundColor = UIColor.init(hexString: "ffffff")
        self.tableView.separatorColor = UIColor.clear
        
        self.tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
       // self.tableview.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor.init(hexString: GlobalConstants.color.grayMedium)
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
        let cell:CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        cell.loadWithComment(comment: currentData[indexPath.row])
      //  delegate?.checkFollowing(indexPath: indexPath,user:currentData[indexPath.row])
        return cell
    }
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
        return 70*valuePro;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //nada no hacemos nada
    }
    // MARK: - Firebase
    func updateWithData(list:[Comment]){
        
        currentData = list
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.currentData.count-1 && self.isLoading == false {
            self.isLoading = true
            //load new data (new 10 movies)
            pageNumber = pageNumber + 1
            //self.delegate?.loadNewUsers(offset: pageNumber, user: currentData.last!)
        }
    }
    // MARK: - Textfield
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardSize:CGFloat = CGFloat(NSNumber.getKeyboardSize())
     
        tableView.scrollToBottom()
         self.tableView.alpha = 1
        UIView.animate(withDuration: 0.3,animations: {
            self.tableView.frame = CGRect(x: 0, y: 0, width: 320*self.valuePro, height: self.frame.size.height-44*self.valuePro-keyboardSize+self.currentBarHeight+58*self.valuePro)
        }, completion: { _ in
             self.tableView.alpha = 1
        })
    }
  
}
