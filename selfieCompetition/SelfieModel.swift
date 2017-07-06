//
//  SelfieModel.swift
//  selfieCompetition
//
//  Created by Kyle Strem on 4/27/17.
//  Copyright © 2017 Kyle Strem. All rights reserved.
//

import Foundation

class SelfieModel {
  static func uploadSelfie(_ s3_link: String, _ user_id: String, _ img_id: String, completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
    let url = URL(string: "http://52.34.105.49/upload")
    
    var request = URLRequest(url: url!)
    
    request.httpMethod = "POST"
    
    let postString = "s3_link=\(s3_link)&user_id=\(user_id)&img_id=\(img_id)"
    
    request.httpBody = postString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
  }
  
  static func grabAllUserSelfies(_ user_id: String, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
    let url = URL(string: "http://52.34.105.49/getUserSelfies")
    
    var request = URLRequest(url: url!)
    
    request.httpMethod = "POST"
    
    let postString = "user_id=\(user_id)"
    
    request.httpBody = postString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
  }
  
  static func grabRecentSelfies(completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
    let url = URL(string: "http://52.34.105.49/recent")
    
    var request = URLRequest(url: url!)
    
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
  }
}
