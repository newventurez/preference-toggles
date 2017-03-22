//
//  PreferenceToggles.swift
//  PreferenceToggles
//
//  Created by Zane Shannon on 3/22/17.
//  Copyright © 2017 Zane Shannon. All rights reserved.
//

import RxSwift
import UIKit

class PreferenceToggles: UIView {

  var options = []
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    initializeLayers()
  }
  
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    initializeLayers()
  }
  
  private func initializeLayers() {
    self.backgroundColor = UIColor.green
  }

}
