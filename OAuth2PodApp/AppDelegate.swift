//
//  AppDelegate.swift
//  OAuth2PodApp
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		return true
	}
	
	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if "ppoauthapp" == url.scheme || (url.scheme?.hasPrefix("com.googleusercontent.apps"))! {
            if let nc = window?.rootViewController as? UINavigationController {
                if let vc = nc.topViewController as? SignInViewController{
                    vc.oauth2.handleRedirectURL(url)
                    return true
                    
                }
            }
        }
        return false
	}
}

