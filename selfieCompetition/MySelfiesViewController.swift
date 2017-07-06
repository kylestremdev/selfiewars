//
//  MySelfiesViewController.swift
//  selfieCompetition
//
//  Created by Kyle Strem on 4/25/17.
//  Copyright © 2017 Kyle Strem. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore

class MySelfiesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  // MARK: -- Globals
  
  var user_id: String?
  var images: [[String: Any]] = [[String: Any]]()
  
  // MARK: -- UI Elements
  
  @IBOutlet weak var selfiesCollectionView: UICollectionView!
  

  // MARK: -- UI Actions
  
  @IBAction func homeButtonPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    if (user_id != nil) {
      SelfieModel.grabAllUserSelfies(user_id!, completionHandler: {
        data, response, error in
        
        if let httpResponse = response as? HTTPURLResponse {
          
          print(httpResponse.statusCode)
          
          let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2,
                                                                  identityPoolId:"us-west-2:40cb72a1-14ea-4b81-b176-e8d17781f19e")
          
          let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider:credentialsProvider)
          
          AWSServiceManager.default().defaultServiceConfiguration = configuration
          
          if httpResponse.statusCode == 200 {
            do {
              if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                for item in jsonResult {
                  if let image_document = item as? [String: Any] {
                    
                    self.images.append(image_document)
                  }
                }
              
                for (index, var image_dict) in self.images.enumerated() {
                  let transferUtility = AWSS3TransferUtility.default()
                  
                  transferUtility.downloadData(fromBucket: "selfie-wars", key: image_dict["img_id"] as! String, expression: nil, completionHandler: {
                    task, url, data, error in
                    
                    DispatchQueue.main.async {
                      var resultImage: UIImage?
                      
                      if let data = data {
                        resultImage = UIImage(data: data)
                        image_dict["image"] = resultImage
                        self.images[index] = image_dict
                      }
                      
                      print(self.images)
                      self.selfiesCollectionView.reloadData()
                    }
                    
                  })
                }
              }
            } catch {
              print(error)
            }
          } else {
            print("Error")
          }
        }
      })
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print(self.images.count)
    return self.images.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mySelfiesCell", for: indexPath) as! MySelfiesCustomCell
    
    cell.cellImageView.image = self.images[indexPath.row]["image"] as? UIImage
    cell.cellImageView.backgroundColor = UIColor.clear
    cell.cellImageView.contentMode = UIViewContentMode.scaleAspectFit
    
    let wins = self.images[indexPath.row]["wins"] as? NSArray
    let losses = self.images[indexPath.row]["losses"] as? NSArray
    
    cell.cellWinsLabel.text = String(describing: wins?.count)
    cell.cellLossesLabel.text = String(describing: losses?.count)
    
    return cell
  }

}



