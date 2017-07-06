//
//  OutlinedText.swift
//  selfieCompetition
//
//  Created by Kyle Strem on 4/24/17.
//  Copyright © 2017 Kyle Strem. All rights reserved.
//

import UIKit


@IBDesignable
class OutlinedText: UILabel {
  
  var strokeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.black,
    NSForegroundColorAttributeName : UIColor.white,
    NSStrokeWidthAttributeName : -1.0,
  ] as [String : Any]

  @IBInspectable var outlineColor: UIColor = UIColor.black {
    didSet{
      strokeTextAttributes["NSStrokeColorAttributeName"] = outlineColor
      self.attributedText = NSAttributedString(string: self.text!, attributes: strokeTextAttributes)
    }
  }
  
  @IBInspectable var inlineColor: UIColor = UIColor.white {
    didSet{
      strokeTextAttributes["NSForegroundColorAttributeName"] = inlineColor
      self.attributedText = NSAttributedString(string: self.text!, attributes: strokeTextAttributes)
    }
  }
  
  @IBInspectable var outlineWidth: Float = -1.0 {
    didSet{
      strokeTextAttributes["NSStrokeWidthAttributeName"] = outlineWidth
      self.attributedText = NSAttributedString(string: self.text!, attributes: strokeTextAttributes)
    }
  }
  
  
  
  override func prepareForInterfaceBuilder() {
    
    super.prepareForInterfaceBuilder()
  }

}
