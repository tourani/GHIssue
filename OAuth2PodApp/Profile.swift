//
//  Profile.swift
//  OAuth2PodApp
//
//  Created by Sanjay on 1/25/17.
//
 import UIKit
 
 class Profile: NSObject {
 
    var avatar_url: String
    var created_at: String
    var email: String
    var followers: Int
    var following: Int
    var company: String
    var location: String
    var login: String
    var name: String
    var public_repos: Int
    
    init?(avatar_url: String, created_at: String, email: String, followers: Int, following: Int, company: String, location: String, login: String, name: String, public_repos: Int) {
 
        self.avatar_url = avatar_url
        self.created_at = created_at
        self.email = email
        self.followers = followers
        self.following = following
        self.company = company
        self.location = location
        self.login = login
        self.name = name
        self.public_repos = public_repos
 
    }
 }
 
 
