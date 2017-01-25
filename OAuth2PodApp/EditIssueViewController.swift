//
//  EditIssueViewController.swift
//  OAuth2PodApp
//
//  Created by Sanjay on 1/25/17.


import UIKit
import p2_OAuth2
import Alamofire


class EditIssueViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var stateLabel: UILabel!
    
    var loader: OAuth2DataLoader?
    var oauth2: OAuth2CodeGrant?
    var sessionManager: SessionManager?
    var repoName: String?
    var issueNumber: String?
    var locked: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTextView.layer.borderColor = UIColor.black.cgColor
        bodyTextView.layer.borderWidth = 1.0
        
        titleTextField.delegate = self
        bodyTextView.delegate = self
        
        if self.locked == true {
            self.openButton.isHidden = false
            self.closeButton.isHidden = true
            self.stateLabel.text = "This issue is locked"
        }
        else{
            self.openButton.isHidden = true
            self.closeButton.isHidden = false
            self.stateLabel.text = "This issue is unlocked"
        }

       
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }

    }
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        
        let title = titleTextField.text ?? ""
        let body = bodyTextView.text ?? ""
        
        if title.isEmpty{
            let alert = UIAlertController(title: "Empty Field",
                                          message: "Please type the title",
                                          preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                return
            })
            
            alert.addAction(ok)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        let url = "https://api.github.com/repos/" + repoName! + "/issues/" + issueNumber!
       
        sessionManager?.request(url, method: .patch, parameters: ["title": title, "body": body], encoding: JSONEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success:
                
                self.didEditIssue()
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func didEditIssue() {
        let alert = UIAlertController(title: "",
                                      message: "Issue edited successfully",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            return
        })
        
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
        
        self.titleTextField.text = ""
        self.bodyTextView.text = ""
        
    }

    
    @IBAction func onClose(_ sender: UIButton) {
    
        
       let url = "https://api.github.com/repos/" + repoName! + "/issues/" + issueNumber! + "/lock"
        
        sessionManager?.request(url, method: .put).responseJSON {
            response in
            switch response.result {
            case .success:
                
                self.stateLabel.text = "This issue is locked"
                self.changeState()
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
        
    }

    @IBAction func onOpen(_ sender: UIButton) {

     let url = "https://api.github.com/repos/" + repoName! + "/issues/" + issueNumber! + "/lock"
        
        sessionManager?.request(url, method: .delete).responseJSON {
            response in
            switch response.result {
            case .success:
              
                self.changeState()
                self.stateLabel.text = "This issue is unlocked"

                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func changeState() {
        
        self.openButton.isHidden = !self.openButton.isHidden
        self.closeButton.isHidden = !self.closeButton.isHidden
    }
    
    
    // TextField, TextView Delegate
    // Hide the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
