//
//  UserModel.swift
//  selfieCompetition
//
//  Created by Kyle Strem on 4/26/17.
//  Copyright © 2017 Kyle Strem. All rights reserved.
//

import Foundation

class UserModel {
  static func loginUser(_ username: String, _ password: String, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
    let url = URL(string: "http://52.34.105.49/login")
    
    var request = URLRequest(url: url!)
    
    request.httpMethod = "POST"
    
    let password_hash = PasswordEncrypter().pbkdf2SHA256(password: password)!
    
    let postString = "username=\(username)&password_hash=\(password_hash as NSData)"
    
    request.httpBody = postString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
  }
  
  static func registerUser(_ email: String, _ username: String, _ password: String, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
    let url = URL(string: "http://52.34.105.49/register")
    
    var request = URLRequest(url: url!)
    
    request.httpMethod = "POST"
    
    let password_hash = PasswordEncrypter().pbkdf2SHA256(password: password)!
    
    let postString = "email=\(email)&username=\(username)&password_hash=\(password_hash as NSData)"
    
    request.httpBody = postString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
  }
  
  static func getUser(_ user_id: String, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
    let url = URL(string: "http://52.34.105.49/getUser")
    
    var request = URLRequest(url: url!)
    
    request.httpMethod = "POST"
    
    let postString = "user_id=\(user_id)"
    
    request.httpBody = postString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
  }
}
