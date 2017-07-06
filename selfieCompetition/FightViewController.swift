//
//  FightViewController.swift
//  selfieCompetition
//
//  Created by Kyle Strem on 4/25/17.
//  Copyright © 2017 Kyle Strem. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore

class FightViewController: UIViewController {
  
  // MARK: -- Globals
  
  var user_id: String?
  var showImage: UIImage?
  var fight_id: String?
  
  // MARK: -- UI Elements
  
  @IBOutlet weak var leftFightImageView: UIImageView!
  @IBOutlet weak var rightfightImageView: UIImageView!
  
  
  // MARK: -- UI Actions
  
  @IBAction func homeButtonPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func leftPictureButtonPressed(_ sender: UIButton) {
    self.showImage = leftFightImageView.image!
    
    self.performSegue(withIdentifier: "fightShowPictureSegue", sender: self)
  }
  
  @IBAction func rightPictureButtonPressed(_ sender: UIButton) {
    self.showImage = rightfightImageView.image!
    
    self.performSegue(withIdentifier: "fightShowPictureSegue", sender: self)
  }
  
  @IBAction func leftButtonPressed(_ sender: UIButton) {
    
    print("left button pressed")
    
    FightModel.updateFight(fight_id!, user_id!, left: 1, right: 0, none: 0, completionHandler: {
      data, response, error in
      
      if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 200 {
          
          DispatchQueue.main.async {
            self.leftFightImageView.image = nil
            self.rightfightImageView.image = nil
            
            print("success")
            self.getFight()
          }
          
          
        } else {
          print("error")
          self.getFight()
        }
      } else {
        print("error")
      }
    })
  }
  
  @IBAction func rightButtonPressed(_ sender: UIButton) {
    
    print("right button pressed")
    
    
    FightModel.updateFight(fight_id!, user_id!, left: 0, right: 1, none: 0, completionHandler: {
      data, response, error in
      
      if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 200 {
          
          DispatchQueue.main.async {
            self.leftFightImageView.image = nil
            self.rightfightImageView.image = nil
            
            print("success")
            self.getFight()
          }
          
        } else {
          print("error")
          self.getFight()
        }
      }
    })
  }
  
  @IBAction func noneButtonPressed(_ sender: UIButton) {
    
    print("none button pressed")
    
    FightModel.updateFight(fight_id!, user_id!, left: 0, right: 0, none: 1, completionHandler: {
      data, response, error in
      
      if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 200 {
          
          DispatchQueue.main.async {
            self.leftFightImageView.image = nil
            self.rightfightImageView.image = nil
            
            print("success")
            self.getFight()
          }
          
        } else {
          print("error")
          self.getFight()
        }
      }
    })
  }
  

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    if user_id != nil {
      getFight()
    }
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "fightShowPictureSegue" {
      let fightShowViewController = segue.destination as! FightShowViewController
      
      fightShowViewController.image = self.showImage!
    }
  }
  
  func getFight() {
    FightModel.getFight(user_id!, completionHandler: {
      data, response, error in
      
      if let httpResponse = response as? HTTPURLResponse {
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2,
                                                                identityPoolId:"us-west-2:40cb72a1-14ea-4b81-b176-e8d17781f19e")
        
        let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        if httpResponse.statusCode == 200 {
          do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
              
              self.fight_id = jsonResult["_id"] as? String
              
              if let left = jsonResult["left"] as? NSDictionary {
                let transferUtility = AWSS3TransferUtility.default()
                
                
                
                transferUtility.downloadData(fromBucket: "selfie-wars", key: left["img_id"]! as! String, expression: nil, completionHandler: {
                  task, url, data, error in
                  
                  var resultImage: UIImage?
                  
                  if let data = data {
                    resultImage = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                      self.leftFightImageView.image = resultImage
                      self.leftFightImageView.backgroundColor = UIColor.clear
                      self.leftFightImageView.contentMode = .scaleToFill
                    }
                  }
                  
                  if let right = jsonResult["right"] as? NSDictionary {
                    let transferUtility = AWSS3TransferUtility.default()
                    
                    
                    
                    transferUtility.downloadData(fromBucket: "selfie-wars", key: right["img_id"]! as! String, expression: nil, completionHandler: {
                      task, url, data, error in
                      
                      var resultImage: UIImage?
                      
                      if let data = data {
                        resultImage = UIImage(data: data)
                        
                        DispatchQueue.main.async {
                          self.rightfightImageView.image = resultImage
                          self.rightfightImageView.backgroundColor = UIColor.clear
                          self.rightfightImageView.contentMode = .scaleToFill
                        }
                      }
                    })
                  }
                })
              }
              
            }
          } catch {
            print(error)
          }
        }
      }
    })
  }

}
