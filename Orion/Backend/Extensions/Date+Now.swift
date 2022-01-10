//
//  Date+Now.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/03.
//

import Foundation

extension Date {
  /// For some reason, this only exists on macOS 12...
  /// So stupid.
  static var now: Date {
    return Date(timeIntervalSinceNow: 0)
  }
}
