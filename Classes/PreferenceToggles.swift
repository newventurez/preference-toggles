//
//  PreferenceToggles.swift
//  PreferenceToggles
//
//  Created by Zane Shannon on 3/22/17.
//  Copyright © 2017 Zane Shannon. All rights reserved.
//

import RxSwift
import UIKit

public class Preference {
  public var option: String = ""
  public var state: Variable<State> = Variable(.allow)
  
  public init(_ option:String, state: State = .allow) {
    self.option = option
    self.state.value = state
  }
  
  public enum State {
    case prefer
    case allow
    case prohibit
  }
}

public class PreferenceToggles: UIView {
  
  public var options = Variable<[Preference]>([])
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    initialize()
  }
  
  private let disposeBag = DisposeBag()
  private let allow_label = UILabel(frame: CGRect.zero)
  private let prefer_label = UILabel(frame: CGRect.zero)
  private let prohibit_label = UILabel(frame: CGRect.zero)
  private let scroll_view = UIScrollView(frame: CGRect.zero)
  private let spacing = CGFloat(8.0)
  private let stack_view = UIStackView(frame: CGRect.zero)
  
  private func initialize() {
    // setup stack view
    translatesAutoresizingMaskIntoConstraints = false
    
    allow_label.text = "Allow"
    allow_label.textAlignment = .right
    allow_label.translatesAutoresizingMaskIntoConstraints = false
    allow_label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
    addSubview(allow_label)
    allow_label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    allow_label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing).isActive = true
    
    prefer_label.text = "Prefer"
    prefer_label.textAlignment = .right
    prefer_label.translatesAutoresizingMaskIntoConstraints = false
    prefer_label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
    addSubview(prefer_label)
    prefer_label.bottomAnchor.constraint(equalTo: allow_label.topAnchor, constant: -5 * spacing).isActive = true
    prefer_label.leadingAnchor.constraint(equalTo: allow_label.leadingAnchor).isActive = true
    prefer_label.widthAnchor.constraint(equalTo: allow_label.widthAnchor).isActive = true
    
    prohibit_label.text = "Prohibit"
    prohibit_label.textAlignment = .right
    prohibit_label.translatesAutoresizingMaskIntoConstraints = false
    prohibit_label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
    addSubview(prohibit_label)
    prohibit_label.leadingAnchor.constraint(equalTo: allow_label.leadingAnchor).isActive = true
    prohibit_label.topAnchor.constraint(equalTo: allow_label.bottomAnchor, constant: 5 * spacing).isActive = true
    prohibit_label.widthAnchor.constraint(equalTo: allow_label.widthAnchor).isActive = true
    
    scroll_view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(scroll_view)
    scroll_view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    scroll_view.leadingAnchor.constraint(equalTo: allow_label.trailingAnchor, constant: spacing).isActive = true
    scroll_view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    scroll_view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    
    stack_view.alignment = .center
    stack_view.axis = .horizontal
    stack_view.distribution = .fillProportionally
    stack_view.isLayoutMarginsRelativeArrangement = true
    stack_view.layer.zPosition = 1
    stack_view.layoutMargins = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    stack_view.spacing = spacing
    stack_view.translatesAutoresizingMaskIntoConstraints = false
    scroll_view.addSubview(stack_view)
    
    stack_view.bottomAnchor.constraint(equalTo: scroll_view.bottomAnchor).isActive = true
    stack_view.heightAnchor.constraint(equalTo: scroll_view.heightAnchor).isActive = true
    stack_view.leadingAnchor.constraint(equalTo: scroll_view.leadingAnchor).isActive = true
    stack_view.topAnchor.constraint(equalTo: scroll_view.topAnchor).isActive = true
    stack_view.trailingAnchor.constraint(equalTo: scroll_view.trailingAnchor).isActive = true
    
    // subscribe to options changes
    let options_subscription = self.options.asObservable().subscribe { (e: Event) -> Void in
      self.renderOptions()
    }
    self.disposeBag.insert(options_subscription)
  }
  
  private func renderOptions() {
    stack_view.arrangedSubviews.forEach { (view) in
      stack_view.removeArrangedSubview(view)
      view.removeFromSuperview()
    }
    options.value.forEach { (preference) in
      let preferenceView = TogglePreferenceView(spacing: self.spacing)
      preferenceView.preference.value = preference
      self.stack_view.addArrangedSubview(preferenceView)
    }
  }

}

private class TogglePreferenceView: UIView {
  private let disposeBag = DisposeBag()
  private let animation_speed = 0.25
  
  public var preference = Variable<Preference?>(nil)
  private var spacing: CGFloat = 8.0
  private let label = UILabel(frame: CGRect.zero)
  private let shadowView = UIView(frame: CGRect.zero)
  
  init(spacing: CGFloat) {
    super.init(frame: CGRect.zero)
    self.spacing = spacing
    initialize()
  }
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    initialize()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: layer.cornerRadius, height: layer.cornerRadius)).cgPath
  }
  
  private func initialize() {
    isUserInteractionEnabled = true
    translatesAutoresizingMaskIntoConstraints = false
    
    label.backgroundColor = UIColor.blue
    label.layer.borderColor = UIColor.clear.cgColor
    label.layer.borderWidth = 2.0
    label.layer.cornerRadius = 8.0
    label.layer.masksToBounds = true
    label.layer.zPosition = 3
    label.isUserInteractionEnabled = false
    label.textAlignment = .center
    label.textColor = UIColor.white
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    
    shadowView.backgroundColor = UIColor.green
    shadowView.isUserInteractionEnabled = false
    shadowView.layer.borderColor = UIColor.clear.cgColor
    shadowView.layer.borderWidth = 2.0
    shadowView.layer.cornerRadius = 8.0
    shadowView.layer.masksToBounds = false
    shadowView.layer.opacity = 0.0
    shadowView.layer.rasterizationScale = UIScreen.main.scale
    shadowView.layer.shadowColor = UIColor.black.cgColor
    shadowView.layer.shadowOffset = CGSize.zero
    shadowView.layer.shadowOpacity = 0.4
    shadowView.layer.shadowRadius = 6.0
    shadowView.layer.shouldRasterize = true
    shadowView.layer.zPosition = 2
    shadowView.translatesAutoresizingMaskIntoConstraints = false
    
    insertSubview(shadowView, belowSubview: label)
    
    self.heightAnchor.constraint(equalToConstant: self.spacing * 5).isActive = true
    
    label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    label.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    label.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    shadowView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    shadowView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    shadowView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    shadowView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    
    let optionSubscription = self.preference.asObservable().subscribe { (e: Event) -> Void in
      if let preference = e.element {
        self.label.text = preference?.option
        if let stateSubscription = preference?.state.asObservable().subscribe({ (e: Event) -> Void in
          if let state = e.element {
            UIView.animate(withDuration: self.animation_speed, animations: {
              switch state {
              case .allow:
                self.label.backgroundColor = UIColor.blue
                break
              case .prefer:
                self.label.backgroundColor = UIColor.green
                break
              case .prohibit:
                self.label.backgroundColor = UIColor.red
                break
              }
            })
          }
        }) {
          self.disposeBag.insert(stateSubscription)
        }
      }
    }
    self.disposeBag.insert(optionSubscription)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.shadowView.layer.opacity = 1.0
    if let scrollView = superview?.superview as? UIScrollView {
      scrollView.isScrollEnabled = false
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    center.y = (touches.first?.location(in: superview!))!.y
    let middle = superview!.frame.size.height / 2
    if center.y - frame.height > middle {
      self.preference.value?.state.value = .prohibit
    }
    else if center.y + frame.height < middle {
      self.preference.value?.state.value = .prefer
    }
    else {
      self.preference.value?.state.value = .allow
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.shadowView.layer.opacity = 0.0
    let middle = superview!.frame.size.height / 2
    UIView.animate(withDuration: self.animation_speed, animations: {
      switch self.preference.value!.state.value {
      case .allow:
        self.center.y = middle
        break
      case .prefer:
        self.center.y = middle - (self.spacing * 8)
        break
      case .prohibit:
        self.center.y = middle + (self.spacing * 8)
        break
      }
    })
    if let scrollView = superview?.superview as? UIScrollView {
      scrollView.isScrollEnabled = true
    }
  }
  
}
