//
//  SignUpViewController.swift
//  selfieCompetition
//
//  Created by Kyle Strem on 4/24/17.
//  Copyright © 2017 Kyle Strem. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
  
  // MARK: -- Globals
  
  var user: NSDictionary?
  
  // MARK: -- UI Elements
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasstextField: UITextField!
  @IBOutlet var errorMessageLabelCollection: [UILabel]!
  @IBOutlet weak var uniqueErrorLabel: UILabel!
  
  
  // MARK: -- UI Actions
  
  @IBAction func cancelButtonPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func signUpButtonPressed(_ sender: UIButton) {
    
    for item in errorMessageLabelCollection {
      if item.textColor != UIColor.green {
        print("Denied")
        
        return
      }
    }
    
    UserModel.registerUser(emailTextField.text!, usernameTextField.text!, passwordTextField.text!, completionHandler: {
      data, response, error in
      
      if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 200 {
          do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
              DispatchQueue.main.async {
                UserDefaults.standard.set(jsonResult["_id"]! as! String, forKey: "user_id")
                
                self.user = jsonResult
                
                self.performSegue(withIdentifier: "homeFromSignUpSegue", sender: sender)
              }
            }
          } catch {
            print(error)
          }
        } else {
          
          DispatchQueue.main.async {
            for item in self.errorMessageLabelCollection {
              item.isHidden = true
              item.textColor = UIColor.red
            }
            
            self.emailTextField.text = ""
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
            self.confirmPasstextField.text = ""
            
            self.uniqueErrorLabel.isHidden = false
          }
          return
        }
      } else {
        return
      }
    })
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    emailTextField.delegate = self
    usernameTextField.delegate = self
    passwordTextField.delegate = self
    confirmPasstextField.delegate = self
    
    emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    confirmPasstextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if (emailTextField.text?.characters.count)! > 0 {
      dismiss(animated: true, completion: nil)
    }
  }
    
  // MARK: -- TextField Delegate Functions
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if uniqueErrorLabel.isHidden == false {
      uniqueErrorLabel.isHidden = true
      
      for item in errorMessageLabelCollection {
        item.isHidden = false
      }
    }
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if uniqueErrorLabel.isHidden == false {
      uniqueErrorLabel.isHidden = true
      
      for item in errorMessageLabelCollection {
        item.isHidden = false
      }
    }
  }
  
  func textFieldDidChange(_ textField: UITextField) {
    if uniqueErrorLabel.isHidden == false {
      uniqueErrorLabel.isHidden = true
      
      for item in errorMessageLabelCollection {
        item.isHidden = false
      }
    }
    
    
    switch textField.tag {
      case 0:
        handleEmailTextFieldChange(textField.text!)
  
      case 1:
        handleUsernameTextFieldChange(textField.text!)
  
      case 2:
        handlePasswordTextFieldChange(textField.text!)
  
      case 3:
        handleConfirmPassTextFieldChange(textField.text!)
        
      default: break
        // Do nothing
    }
  }
  
  // MARK: -- TextField Delegation Function helpers
  func handleEmailTextFieldChange(_ text: String) {
    let regexp = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    if let range = text.range(of: regexp, options: .regularExpression) {
      let result = text.substring(with: range)
      if result.characters.count > 0 {
        errorMessageLabelCollection[1].textColor = UIColor.green
      }
    } else {
      errorMessageLabelCollection[1].textColor = UIColor.red
    }
  }
  
  func handleUsernameTextFieldChange(_ text: String) {
    if text.characters.count > 4 {
      errorMessageLabelCollection[2].textColor = UIColor.green
    } else {
      errorMessageLabelCollection[2].textColor = UIColor.red
    }
  }
  
  func handlePasswordTextFieldChange(_ text: String) {
    let regexp = "^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$"
    
    if let range = text.range(of: regexp, options: .regularExpression) {
      let result = text.substring(with: range)
      if result.characters.count > 0 {
        errorMessageLabelCollection[4].textColor = UIColor.green
      }
    } else {
      errorMessageLabelCollection[4].textColor = UIColor.red
    }
    
    if text.characters.count > 7 {
      errorMessageLabelCollection[3].textColor = UIColor.green
    } else {
      errorMessageLabelCollection[3].textColor = UIColor.red
    }
  }
  
  func handleConfirmPassTextFieldChange(_ text: String) {
    if text == passwordTextField.text {
      errorMessageLabelCollection[5].textColor = UIColor.green
    } else {
      errorMessageLabelCollection[5].textColor = UIColor.red
    }
  }
  
  // MARK: -- Segue Logic
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "homeFromSignUpSegue" {
      let homeViewController = segue.destination as! HomeViewController
      
      homeViewController.user = self.user!
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField!) -> Bool
  {
    textField.resignFirstResponder()
    return true;
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, with: event)
  }
  
  

}
