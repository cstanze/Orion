//
//  OrionTabSearchField.swift
//  Orion
//
//  Created by Jules Amalie on 2021/12/31.
//

/*
 * IMPORTANT
 * ---------
 * This code is currently unused and considered "dead code". Refrain from using this code. It sucks anyways...
 */

import Cocoa

/// Just a nice enum so that we don't just use boolean
/// Makes things look cleaner...
enum OrionTabSearchFieldPriority {
  case high
  case low
}

class OrionTabSearchField: NSTextField {
//  weak var tabDelegate: OrionTabSearchFieldDelegate?
  private var priorityWidthConstraint: NSLayoutConstraint?
  private var currentLocation: URL?
  private var lastStringValue: String = ""
  private var _isFocused = false
  var isFocused: Bool {
    get {
      return _isFocused
    }

    set {
      /// If we focus this tab, we'd want to unfocus all others
      if newValue {
        /// Fix all other tabs first
//        self.tabDelegate?.didFocusTab(withView: self)
      }
      searchFieldPriority(newValue ? .high : .low)
      if let locString = currentLocation?.absoluteString {
        self.cell?.stringValue = locString
      }
      _isFocused = newValue
    }
  }

  init() {
    super.init(frame: NSRect(x: 0, y: 0, width: 0, height: 0))

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(locationDidChange),
      name: .TabLocationChanged,
      object: nil
    )
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  @objc func locationDidChange(_ notification: NSNotification) {
    if let location = notification.object as? URL {
      self.currentLocation = location
      if let components = URLComponents(url: location, resolvingAgainstBaseURL: false) {
        let cell = (self.cell as? NSTextFieldCell)!
        cell.stringValue = components.host!.replacingOccurrences(of: "www.", with: "")
      }
    } else {
      // TODO: Finish this else clause
    }
  }

  func initialiseConstraints() {
    guard window != nil else { return }

//    if let tabDelegate = tabDelegate {
//      if tabDelegate.tabCount() == 1 {
//        self.priorityWidthConstraint =
//          self.widthAnchor.constraint(equalTo: window!.contentView!.widthAnchor, multiplier: 0.625)
//      } else {
//        self.priorityWidthConstraint = self.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)
//      }
//      
//      NSLayoutConstraint.activate([
//        self.heightAnchor.constraint(equalToConstant: 29),
//        self.priorityWidthConstraint!
//      ])
//    }
  }

  private func searchFieldPriority(_ priority: OrionTabSearchFieldPriority) {
    NSAnimationContext.runAnimationGroup({ ctx in
      ctx.timingFunction = .init(name: .easeInEaseOut)
      priorityWidthConstraint?.animator().constant = priority == .high ? 300 : 50
    })
  }

  override func becomeFirstResponder() -> Bool {
    isFocused = true

    return super.becomeFirstResponder()
  }

  override func textDidEndEditing(_ notification: Notification) {
    super.textDidEndEditing(notification)

    guard self.stringValue != lastStringValue else { return }

    NotificationCenter.default.post(name: .UserChangedTabLocation, object: self.stringValue)
    lastStringValue = self.stringValue
//    self.currentEditor()?.selectedRange = NSMakeRange(0, 0)
    window?.makeFirstResponder(nil)
  }

  override func resignFirstResponder() -> Bool {
//    self.currentEditor()?.selectedRange = NSMakeRange(0, 0)

    return super.resignFirstResponder()
  }
}
