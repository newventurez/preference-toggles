# PreferenceToggles


## What is it?

PreferenceToggles is a Swift User Interface that supports user signaling filter intentions.

It supports three intentions: prefer, allow, and prohibit.

We use it for search filtering; ours is a list of manufacturers, and our users use PreferenceToggles to indicate which manufacturers' products they'd like to be shown.


## Installation

### CocoaPods

Add the following to your Podfile.

```ruby
pod 'PreferenceToggles', '~> 1.0.0'
```

## Getting Started

PreferenceToggles is entirely written in Swift and will only ever support Swift.

### Basic Usage

You need to instantiate `PreferenceToggles` (a subclass of `UIView`), and put it in front of your user.

You need to instantiate *n* instances of `Preference` using the initializer `Preference("Name of Option")`, passing the string you want rendered for your user to read.

Here's the minimal parts of the example ViewController (pulled mostly from `Example/ViewController.swift`).

```swift
import PreferenceToggles
import RxSwift
import UIKit

class ViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let preference_toggles = PreferenceToggles(frame: CGRect.zero)

  @IBOutlet weak var preferenceView: UIView?

  override func viewDidLoad() {
    super.viewDidLoad()
    // you need to make some Preference objects for your user to consider
    preference_toggles.options.value = ["Apple", "Banana", "Grapefruit", "Orange", "Peach", "Pear"].map{ Preference($0) }
    // we use reactive methodologies to track their inputs
    let optionsSubscription = preference_toggles.options.asObservable().subscribe { (e: Event) -> Void in
      if let options = e.element {
        // we care if our user changes any of the Preference options we presented
        let stateSubscription = Observable.combineLatest(options.map{ return $0.state.asObservable() }).subscribe { (e: Event) -> Void in
          // you might like to find the options your user preferred
          options.filter{ $0.state.value == .prefer }.map{ $0.option }
          // or the ones your user allowed
          options.filter{ $0.state.value == .allow }.map{ $0.option }
          // or especially the ones your user prohibited, ew!
          options.filter{ $0.state.value == .prohibit }.map{ $0.option }
        }
        self.disposeBag.insert(stateSubscription)
      }
    }
    self.disposeBag.insert(optionsSubscription)
    // here's our hook into Interface Builder.
    // preferenceView is just a UIView placeholder.
    if let preferenceView = preferenceView {
      preferenceView.addSubview(preference_toggles)
      // fill the entire placeholder
      preference_toggles.bottomAnchor.constraint(equalTo: preferenceView.bottomAnchor).isActive = true
      preference_toggles.leadingAnchor.constraint(equalTo: preferenceView.leadingAnchor).isActive = true
      preference_toggles.topAnchor.constraint(equalTo: preferenceView.topAnchor).isActive = true
      preference_toggles.trailingAnchor.constraint(equalTo: preferenceView.trailingAnchor).isActive = true
    }
  }

}
```
