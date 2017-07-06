//
//  JSONconverter.swift
//  selfieCompetition
//
//  Created by Kyle Strem on 4/27/17.
//  Copyright © 2017 Kyle Strem. All rights reserved.
//

import Foundation

class JSONconverter {
  
  static func convertJSONDict(_ data: Data) -> NSDictionary? {
    do {
      // try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
      if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
        return jsonResult
      } else {
        return nil
      }
    } catch {
      print(error)
      return nil
    }
  }
  
  static func convertJSONArray(_ data: Data) -> NSArray? {
    do {
      // try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
      if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
        return jsonResult
      } else {
        return nil
      }
    } catch {
      print(error)
      return nil
    }
  }
  
}
