//
//  FightShowViewController.swift
//  selfieCompetition
//
//  Created by Kyle Strem on 4/28/17.
//  Copyright © 2017 Kyle Strem. All rights reserved.
//

import UIKit

class FightShowViewController: UIViewController {
  
  var image: UIImage?
  
  @IBOutlet weak var showImageView: UIImageView!
  

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    if image != nil {
      self.showImageView.image = image
      self.showImageView.backgroundColor = UIColor.clear
      self.showImageView.contentMode = .scaleToFill
    } else {
      dismiss(animated: true, completion: nil)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    dismiss(animated: true, completion: nil)
  }

}
