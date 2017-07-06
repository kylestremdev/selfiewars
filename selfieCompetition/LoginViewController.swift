//
//  ViewController.swift
//  selfieCompetition
//
//  Created by Kyle Strem on 4/24/17.
//  Copyright © 2017 Kyle Strem. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  // MARK: -- Globals
  
  var user: NSDictionary?
  
  // MARK: -- UI Elements
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var errorLabel: UILabel!
  
  // MARK: -- UI Actions
  @IBAction func loginButtonPressed(_ sender: UIButton) {
    
    if usernameTextField.text?.characters.count == 0 || passwordTextField.text?.characters.count == 0 {
      self.errorLabel.isHidden = true
      return
    }
    
    
    UserModel.loginUser(usernameTextField.text!, passwordTextField.text!, completionHandler: {
      data, response, error in
        print("Data: \(String(describing: data))")
        print("Response: \(String(describing: response))")
        print("Error: \(String(describing: error))")
      
      if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")
        
        if httpResponse.statusCode == 200 {
          self.errorLabel.isHidden = true
          
          do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
              
              DispatchQueue.main.async {
                UserDefaults.standard.set(jsonResult["_id"]! as! String, forKey: "user_id")
                
                self.user = jsonResult
                
                print(jsonResult)
                print(self.user ?? "nil")
                
                self.performSegue(withIdentifier: "homeFromLoginSegue", sender: sender)
              }
              
            }
          } catch {
            print(error)
            return
          }
          
          
        } else {
          DispatchQueue.main.async {
            self.errorLabel.isHidden = false
            
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
            return
          }
        }
        
      } else {
        self.errorLabel.isHidden = false
        return
      }
      
    })
    
  }

  @IBAction func signUpButtonPressed(_ sender: UIButton) {
    performSegue(withIdentifier: "signUpSegue", sender: sender)
  }
  

  override func viewDidLoad() {
    super.viewDidLoad()
    // TODO: If use stored in "session" then automatically go to home view
    
    if let user_id = UserDefaults.standard.string(forKey: "user_id") {
      print(user_id)
      UserModel.getUser(user_id, completionHandler: {
        data, response, error in
        
        if let httpResponse = response as? HTTPURLResponse {
          if httpResponse.statusCode == 200 {
            do {
              if let jsonObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                DispatchQueue.main.async {
                  self.user = jsonObject
                  
                  print(jsonObject)
                  print(self.user ?? "nil")
                  
                  self.performSegue(withIdentifier: "homeFromLoginSegue", sender: self)
                }
              }
            } catch {
              print(error)
            }
          }
        }
      })
    }
    
    errorLabel.isHidden = true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    usernameTextField.text = ""
    passwordTextField.text = ""
    
    errorLabel.isHidden = true
  }
  


  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "homeFromLoginSegue" {
      
      let homeViewController = segue.destination as! HomeViewController
      
      homeViewController.user = self.user!
    }
  }
  
  func textFieldShouldReturn(textField: UITextField!) -> Bool
  {
    textField.resignFirstResponder()
    return true;
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, with: event)
  }

  
}

