//
//  ProfileTableViewController.swift
//  OAuth2PodApp
//
//  Created by Sanjay on 1/23/17.

//

import UIKit
import p2_OAuth2
import Alamofire
import os.log

class IssueTableViewController: UITableViewController {

    
    // MARK -Properties
    var loader: OAuth2DataLoader?
    var oauth2: OAuth2CodeGrant?
    var sessionManager: SessionManager?
    
    var repoName: String?
    var issues = [Issue]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }

    
    func loadData() {
        
        issues.removeAll()
        
        let url = "https://api.github.com/repos/" + repoName! + "/issues"
        
        sessionManager?.request(url).validate().responseJSON { response in
           
            if let array = response.result.value as? [Any]{
                for  dict in array{
                    if let dict = dict as? [String: Any], let title = dict["title"] as? String, let body = dict["body"] as? String, let state = dict["state"] as? String, let comments = dict["comments"] as? Int, let number = dict["number"] as? Int, let locked = dict["locked"] as? Bool {
                        
                        if let issue = Issue(title: title, body: body, state: state, comments: comments, number: number, locked: locked){
                            self.issues.append(issue)
                        }
                        
                    }
                }
                
                self.didGetData()
            }
            
        }
        

    }
    
    func didGetData(){
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return issues.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IssueTableViewCell", for: indexPath) as? IssueTableViewCell else{
            fatalError("The dequeued cell is not an instance of IssueTableViewCell.")
            
        }
        
        let issue = issues[indexPath.row]
        
        cell.titleLabel.text = issue.title
        cell.bodyLabel.layer.borderColor = UIColor.black.cgColor
        cell.bodyLabel.layer.borderWidth = 1.0
        cell.bodyLabel.text = issue.body
        cell.bodyLabel.isUserInteractionEnabled = false
        cell.commentsLabel.text = String(issue.comments) + " comments"
        
        if issue.locked {
            cell.lockedButton.isHidden = false
            cell.unlockedButton.isHidden = true
        }
        else{
            cell.lockedButton.isHidden = true
            cell.unlockedButton.isHidden = false
        }
    
        return cell
   
    }
    
    
    @IBAction func unwindToIssueList(sender: UIStoryboardSegue) {
         //loadData()
        
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "SegueToCreate":
            guard let destVC = segue.destination as? CreateIssueViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            destVC.oauth2 = self.oauth2
            destVC.loader = self.loader
            destVC.sessionManager = self.sessionManager
            destVC.repoName = self.repoName
            
        case "SegueToEdit":
            guard let destVC = segue.destination as? EditIssueViewController, let button = sender as? UIButton else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let  cell = button.superview?.superview as? IssueTableViewCell, let indexPath = tableView.indexPath(for: cell) else{
                
                fatalError("cannot find selected cell")
                
            }

            destVC.oauth2 = self.oauth2
            destVC.loader = self.loader
            destVC.sessionManager = self.sessionManager
            destVC.repoName = self.repoName
            destVC.issueNumber = String(self.issues[indexPath.row].number)
            destVC.locked = self.issues[indexPath.row].locked
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }

    }
}
