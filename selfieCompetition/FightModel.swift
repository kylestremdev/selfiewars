//
//  FightModel.swift
//  selfieCompetition
//
//  Created by Kyle Strem on 4/28/17.
//  Copyright © 2017 Kyle Strem. All rights reserved.
//

import Foundation

class FightModel {
  static func getFight(_ user_id: String, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
    let url = URL(string: "http://52.34.105.49/fight/\(user_id)")
    
    var request = URLRequest(url: url!)
    
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
  }
  
  static func updateFight(_ fight_id: String, _ user_id: String, left: Int?, right: Int?, none: Int?, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
    let url = URL(string: "http://52.34.105.49/fightFinish")
    
    var request = URLRequest(url: url!)
    
    request.httpMethod = "POST"
    
    let postString = "fight_id=\(fight_id)&user_id=\(user_id)&left_win=\(String(describing: left!))&right_win=\(String(describing: right!))&none=\(String(describing: none!))"
    
    request.httpBody = postString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
  }
}
