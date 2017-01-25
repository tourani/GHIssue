//
//  IssueViewController.swift
//  OAuth2PodApp
//
//  Created by Sanjay on 1/24/17.
//

import UIKit
import p2_OAuth2
import Alamofire

class CreateIssueViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    //MARK -Properties
    @IBOutlet weak var titleTextFiled: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    var loader: OAuth2DataLoader?
    var oauth2: OAuth2CodeGrant?
    var sessionManager: SessionManager?
    var repoName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextView.layer.borderColor = UIColor.black.cgColor
        commentTextView.layer.borderWidth = 1.0
        
        titleTextFiled.delegate = self
        commentTextView.delegate = self
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Actions
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        let title = titleTextFiled.text ?? ""
        let body = commentTextView.text ?? ""
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
        
        let url = "https://api.github.com/repos/" + repoName! + "/issues"
 
        sessionManager?.request(url, method: .post, parameters: ["title": title, "body": body], encoding: JSONEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                self.didCreateIssue()
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
                dismissViewController()
    }
    
    // UITextViewDelegate
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
    
    func didCreateIssue() {
        let alert = UIAlertController(title: "",
                                      message: "New Issue created successfully",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            return
        })
        
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
        
        self.titleTextFiled.text = ""
        self.commentTextView.text = ""
        
    }
    
    func dismissViewController() {
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
   

}
