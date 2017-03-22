//
//  ViewController.swift
//  PreferenceToggles
//
//  Created by Zane Shannon on 3/22/17.
//  Copyright © 2017 Zane Shannon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var preferenceView: UIView?
  let preference_toggles = PreferenceToggles(frame: CGRect.zero)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    preference_toggles.options = ["Apple", "Banana", "Grapefruit", "Orange", "Peach", "Pear"]
    if let preferenceView = preferenceView {
      preferenceView.addSubview(preference_toggles)
    }
  }
  
  // link to auto-layout changes
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if let preferenceView = preferenceView {
      preference_toggles.frame.size = preferenceView.frame.size
    }
  }

}

