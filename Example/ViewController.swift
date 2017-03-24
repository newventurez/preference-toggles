//
//  ViewController.swift
//  PreferenceToggles
//
//  Created by Zane Shannon on 3/22/17.
//  Copyright © 2017 Zane Shannon. All rights reserved.
//

import PreferenceToggles
import RxSwift
import UIKit

class ViewController: UIViewController {
  private let disposeBag = DisposeBag()
  
  @IBOutlet weak var preferenceView: UIView?
  @IBOutlet weak var preferTextView: UITextView?
  @IBOutlet weak var allowTextView: UITextView?
  @IBOutlet weak var prohibitTextView: UITextView?
  
  let preference_toggles = PreferenceToggles(frame: CGRect.zero)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    preference_toggles.options.value = ["Apple", "Banana", "Grapefruit", "Orange", "Peach", "Pear", "Apple", "Banana", "Grapefruit", "Orange", "Peach", "Pear"].map{ Preference($0) }
    let optionsSubscription = preference_toggles.options.asObservable().subscribe { (e: Event) -> Void in
      if let options = e.element {
        let stateSubscription = Observable.combineLatest(options.map{ return $0.state.asObservable() }).subscribe { (e: Event) -> Void in
          self.preferTextView?.text = options.filter{ $0.state.value == .prefer }.map{ $0.option }.joined(separator: ", ")
          self.allowTextView?.text = options.filter{ $0.state.value == .allow }.map{ $0.option }.joined(separator: ", ")
          self.prohibitTextView?.text = options.filter{ $0.state.value == .prohibit }.map{ $0.option }.joined(separator: ", ")
        }
        self.disposeBag.insert(stateSubscription)
      }
    }
    self.disposeBag.insert(optionsSubscription)
    if let preferenceView = preferenceView {
      preferenceView.addSubview(preference_toggles)
      preference_toggles.bottomAnchor.constraint(equalTo: preferenceView.bottomAnchor).isActive = true
      preference_toggles.leadingAnchor.constraint(equalTo: preferenceView.leadingAnchor).isActive = true
      preference_toggles.topAnchor.constraint(equalTo: preferenceView.topAnchor).isActive = true
      preference_toggles.trailingAnchor.constraint(equalTo: preferenceView.trailingAnchor).isActive = true
    }
  }

}

