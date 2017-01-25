//
//  Issue.swift
//  OAuth2PodApp
//
//  Created by Sanjay on 1/24/17.
//

import UIKit

class Issue: NSObject {
    
    var title: String
    var body: String
    var state: String
    var comments: Int
    var number: Int
    var locked: Bool
        
    init?(title: String, body: String, state: String, comments: Int, number: Int, locked: Bool) {
        
        self.title = title
        self.body = body
        self.state = state
        self.comments = comments
        self.number = number
        self.locked = locked
            
    }
}
