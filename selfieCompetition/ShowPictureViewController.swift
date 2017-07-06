//
//  ShowPictureViewController.swift
//  selfieCompetition
//
//  Created by Kyle Strem on 4/27/17.
//  Copyright © 2017 Kyle Strem. All rights reserved.
//

import UIKit
import AWSCore
import AWSCognito
import AWSS3
import Photos

class ShowPictureViewController: UIViewController {
  
  // MARK: -- Globals
  
  var image: UIImage?
  var imageUrl: URL?
  var user_id: String?
  
  // MARK: -- UI Elements
  
  @IBOutlet weak var showImageView: UIImageView!
  
  // MARK: -- UI Actions
  
  @IBAction func xButtonPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func oButtonPressed(_ sender: UIButton) {
    
    var localFileName: String?
    
    if let imageToUploadUrl = imageUrl {
      let phResult = PHAsset.fetchAssets(withALAssetURLs: [imageToUploadUrl], options: nil).firstObject!
      PHImageManager.default().requestImageData(for: phResult, options: nil, resultHandler: {
        _, _, _, info in
        if let fileName = (info?["PHImageFileURLKey"] as? NSURL)?.lastPathComponent {
          print(fileName)
          localFileName = fileName
        }
        if localFileName == nil {
          print("localFileName is nil")
          return
        }
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory() + "/" + localFileName!)
        let data = UIImageJPEGRepresentation(self.image!, 0.6)
        do {
          try data?.write(to: fileURL)
        } catch {
          print(error)
        }
        
        // Configure AWS Cognito Credentials
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2,
                                                                identityPoolId:"us-west-2:40cb72a1-14ea-4b81-b176-e8d17781f19e")
        
        let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let S3BucketName = "selfie-wars"
        
        let uploadrequest = AWSS3TransferManagerUploadRequest()
        //    print(imageURL!)
        uploadrequest?.body = fileURL
        uploadrequest?.key  = NSUUID().uuidString
        uploadrequest?.bucket = S3BucketName
        uploadrequest?.contentType  = "image/jpeg"
        
        let transferManager = AWSS3TransferManager.default()
        
        // Perform file upload
        transferManager.upload(uploadrequest!).continueWith(block: {task in
          
          if let error = task.error {
            print("Upload failed with error: (\(error.localizedDescription))")
          }
          
          if task.result != nil {
            let s3URL = URL(string: "https://s3-us-west-2.amazonaws.com/\(S3BucketName)/\(uploadrequest!.key ?? "NIL")")!
            print("Uploaded to:\n\(s3URL)")
            
            SelfieModel.uploadSelfie(s3URL.absoluteString, self.user_id!, uploadrequest!.key!, completionHandler: {
              data, response, error in
              
              if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                  DispatchQueue.main.async {
                    let alertController = UIAlertController(title: nil, message: "Image has been uploaded", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                      _ in
                      self.dismiss(animated: true, completion: nil)
                    })
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                  }
                } else {
                  DispatchQueue.main.async {
                    let alertController = UIAlertController(title: nil, message: "Image was not saved correctly", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                      _ in
                      self.dismiss(animated: true, completion: nil)
                    })
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                  }
                }
              }
            })
          } else {
            print("Unexpected empty result.")
          }
          
          return nil
        })
        
      })
    }
    
    

  }
  
  

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    if (image != nil) {
      showImageView.image = image
      showImageView.backgroundColor = UIColor.clear
      showImageView.contentMode = UIViewContentMode.scaleAspectFit
    } else {
      dismiss(animated: true, completion: nil)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
