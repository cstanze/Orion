//
//  NSObjectProtocol+Observe.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/14.
//

import Foundation

extension NSObjectProtocol where Self: NSObject {
  func observeForChanges<Value: Equatable>(_ keyPath: KeyPath<Self, Value>, changeHandler: @escaping () -> Void) -> NSKeyValueObservation {
    observe(keyPath, options: [.old, .new]) { _, change in
      if change.oldValue != change.newValue {
        changeHandler()
      }
    }
  }
}
