//
//  BorderEditableButton.swift
//  selfieCompetition
//
//  Created by Kyle Strem on 4/24/17.
//  Copyright © 2017 Kyle Strem. All rights reserved.
//

import UIKit

@IBDesignable
class BorderEditableButton: UIButton {

  @IBInspectable var cornerRadius: CGFloat = 0.0 {
    didSet{
      self.layer.cornerRadius = cornerRadius
    }
  }
  
  @IBInspectable var borderWidth: CGFloat = 0.0 {
    
    didSet{
      
      self.layer.borderWidth = borderWidth
    }
  }
  
  
  @IBInspectable var borderColor: UIColor = UIColor.clear {
    
    didSet {
      
      self.layer.borderColor = borderColor.cgColor
    }
  }
  
  override func prepareForInterfaceBuilder() {
    
    super.prepareForInterfaceBuilder()
  }
}
