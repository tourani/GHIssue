//
//  ViewController.swift
//  OAuth2PodApp
//
// 

import UIKit
import p2_OAuth2
import Alamofire


class SignInViewController: UIViewController {
    
   // fileprivate var alamofireManager: SessionManager?
    
    var loader: OAuth2DataLoader?
    
    var oauth2 = OAuth2CodeGrant(settings: [
        "client_id": "8ae913c685556e73a16f",                         // yes, this client-id and secret will work!
        "client_secret": "60d81efcc5293fd1d096854f4eee0764edb2da5d",
        "authorize_uri": "https://github.com/login/oauth/authorize",
        "token_uri": "https://github.com/login/oauth/access_token",
        "scope": "repo",
        "redirect_uris": ["ppoauthapp://oauth/callback"],            // app has registered this scheme
        "secret_in_body": true,                                      // GitHub does not accept client secret in the Authorization header
        "verbose": true,
        ] as OAuth2JSON)
    
    @IBOutlet var signInEmbeddedButton: UIButton?
    @IBOutlet var forgetButton: UIButton?
    
    
    @IBAction func signInEmbedded(_ sender: UIButton?) {
        if oauth2.isAuthorizing {
            oauth2.abortAuthorization()
            return
        }
        
        sender?.setTitle("Authorizing...", for: UIControlState.normal)
        
        oauth2.authConfig.authorizeEmbedded = true
        oauth2.authConfig.authorizeContext = self
        let loader = OAuth2DataLoader(oauth2: oauth2)
        self.loader = loader
        
        loader.perform(request: userDataRequest) { response in
            do {
                let json = try response.responseJSON()
                self.didSignIn()
                
            }
            catch let error {
                self.didCancelOrFail(error)
            }
        }
    }
    
    @IBAction func forgetTokens(_ sender: UIButton?) {
       
        oauth2.forgetTokens()
        oauth2.abortAuthorization()
        //let storage = HTTPCookieStorage.shared
        //storage.cookies?.forEach() { storage.deleteCookie($0) }
        resetButtons()
    }
    
    
    // MARK: - Actions
    
    var userDataRequest: URLRequest {
        var request = URLRequest(url: URL(string: "https://api.github.com/user")!)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        return request
    }
    
    func didSignIn() {
    
        self.signInEmbeddedButton?.isHidden = true
        self.forgetButton?.isHidden = false
        
        self.performSegue(withIdentifier: "SegueToProfile", sender: nil)
    }
    
    func didCancelOrFail(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Authorization went wrong: \(error)")
            }
            self.resetButtons()
        }
    }
    
    func resetButtons() {
        signInEmbeddedButton?.setTitle("Sign In (Embedded)", for: UIControlState())
        signInEmbeddedButton?.isEnabled = true
        signInEmbeddedButton?.isHidden = false
        forgetButton?.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let destVC = segue.destination as? ProfileViewController else{
            print("ERROR-cannot init destination View Controller")
            return
        }
        destVC.loader = self.loader
        destVC.oauth2 = self.oauth2
        
        
    }
}



