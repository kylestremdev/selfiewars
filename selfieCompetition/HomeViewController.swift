//
//  HomeViewController.swift
//  selfieCompetition
//
//  Created by Kyle Strem on 4/24/17.
//  Copyright © 2017 Kyle Strem. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
  
  // MARK: -- Globals
  
  var user: NSDictionary?
  var showImage: UIImage?
  var showImageUrl: URL?
  
  
  // MARK: -- UI Actions
  
  @IBAction func signOutButtonPressed(_ sender: UIButton) {
    UserDefaults.standard.removeObject(forKey: "user_id")
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func uploadButtonPressed(_ sender: UIButton) {
    
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let cameraButton = UIAlertAction(title: "Camera", style: .default, handler: {
      UIAlertAction in
      
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
      }
    })
    
    let photoLibraryButton = UIAlertAction(title: "Photo Library", style: .default, handler: {
      UIAlertAction in
      
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
      }
    })
    
    let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    actionSheet.addAction(cameraButton)
    actionSheet.addAction(photoLibraryButton)
    actionSheet.addAction(cancelButton)
    
    self.present(actionSheet, animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)      
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
      self.showImage = image
    } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      self.showImage = image
    } else {
      self.showImage = nil
    }
    
    self.showImageUrl = info[UIImagePickerControllerReferenceURL] as? URL
    self.dismiss(animated: true, completion: {
      self.performSegue(withIdentifier: "showPictureSegue", sender: self)
    })
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showPictureSegue" {
      let showPictureViewController = segue.destination as! ShowPictureViewController
      
      showPictureViewController.image = self.showImage!
      showPictureViewController.imageUrl = self.showImageUrl!
      
      showPictureViewController.user_id = self.user!["_id"]! as? String
    } else if segue.identifier == "mySelfiesSegue" {
      let mySelfiesViewController = segue.destination as! MySelfiesViewController
      
      mySelfiesViewController.user_id = self.user!["_id"]! as? String
    } else if segue.identifier == "fightSegue" {
      let fightViewController = segue.destination as! FightViewController
      
      fightViewController.user_id = self.user!["_id"]! as? String
    }
  }
  

}
