//
//  ProfileViewController.swift
//  OAuth2PodApp
//
//  Created by Sanjay on 1/23/17.


import UIKit
import p2_OAuth2
import Alamofire


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var avatarVIew: UIImageView!
  
    //@IBOutlet weak var repoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var loader: OAuth2DataLoader?
    var oauth2: OAuth2CodeGrant?
    var sessionManager: SessionManager?
    var repos = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarVIew.layer.cornerRadius = avatarVIew.frame.size.width/2
        avatarVIew.clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let sessionManager = SessionManager()
        if sessionManager != nil {
            let retrier = OAuth2RetryHandler(oauth2: oauth2!)
            sessionManager.adapter = retrier
            sessionManager.retrier = retrier
        }
        
        self.sessionManager = sessionManager

        sessionManager.request("https://api.github.com/user").validate().responseJSON { response in
           
            if let dict = response.result.value as? [String: Any] {
                print("******user data")
                print(response)
                self.didGetUserdata(dict: dict)
            }
            
        }
        
        sessionManager.request("https://api.github.com/user/repos").validate().responseJSON { response in
           
            if let array = response.result.value as? [Any]{
                for  dict in array{
                    if let dict = dict as? [String: Any], let reponame = dict["full_name"] as? String{
                        
                        self.repos.append(reponame)
                        self.didGetUserRepo()
                    }
                }
                
            }
            
        }
 
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func didGetUserRepo()  {
        
        self.tableView.reloadData()
        
    }
    
    func didGetUserdata(dict: [String: Any]) {
        DispatchQueue.main.async {
            
            if let imgURL = dict["avatar_url"] as? String, let url = URL(string: imgURL) {
                self.loadAvatar(from: url)
            }
            
            if let name = dict["name"] as? String {
                self.nameLabel.text = name
            }
          
            
            if let login = dict["login"] as? String {
                self.loginLabel.text = login
            }
          
            
            if let email = dict["email"] as? String {
                self.emailLabel.text = email
            }
            else {
                self.emailLabel.text = "No Email Address found"
            }

            
            if let company = dict["company"] as? String {
                self.companyLabel.text = company
            }
            else {
                self.companyLabel.text = "No Company found"
            }

            
            if let location = dict["location"] as? String {
                self.locationLabel.text = location
            }
            else {
                self.locationLabel.text = "No location found"
            }


            if let repos = dict["public_repos"] as? Int, let followers = dict["followers"] as? Int, let following = dict["following"] as? Int {
                self.infoLabel.text = String(repos) + " Repositories" + "     " + String(followers) + " followers" + "     " + String(following) + " following"
            }
            else {
                self.infoLabel.text = ""
            }


          
        
        }
    }
    
    func loadAvatar(from url: URL) {
        if let loader = loader {
            loader.perform(request: URLRequest(url: url)) { response in
                do {
                    let data = try response.responseData()
                    DispatchQueue.main.async {
                        self.avatarVIew.image = UIImage(data: data)
                        
                    }
                }
                catch let error {
                    print("Failed to load avatar: \(error)")
                }
            }
        }
        else {
            sessionManager?.request(url).validate().responseData() { response in
                if let data = response.result.value {
                    self.avatarVIew.image = UIImage(data: data)
                    
                }
                else {
                    print("Failed to load avatar: \(response)")
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepoTableViewCell", for: indexPath) as? RepoTableViewCell else{
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        
        cell.repoNameLabel.text = repos[indexPath.row]
        return cell
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let destVC = segue.destination as? IssueTableViewController, let button = sender as? UIButton else{
            fatalError("Segue Error")
        }
        
        guard let  cell = button.superview?.superview as? RepoTableViewCell, let indexPath = tableView.indexPath(for: cell) else{
            
            fatalError("cannot find selected cell")
            
        }
        
        destVC.oauth2 = self.oauth2
        destVC.loader = self.loader
        destVC.sessionManager = self.sessionManager
        destVC.repoName = repos[indexPath.row]
        print(repos[indexPath.row])
       
    }
}
