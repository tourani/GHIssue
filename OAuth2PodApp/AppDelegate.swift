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
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = UIColor(colorLiteralRed: 50/255, green: 130/255, blue: 204/255, alpha: 1)
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = false
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

