//
//  NSNotificationName+Orion.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/01.
//

import Foundation
import Cocoa

extension NSNotification.Name {
  static let OrionControllerWebViewChanged = NSNotification.Name("OrionControllerWebViewChanged")
  static let OrionCurrentTabLocationChangedViaUser = NSNotification.Name("OrionCurrentTabLocationChangedViaUser")
  static let OrionCurrentTabLocationChanged = NSNotification.Name("OrionCurrentTabLocationChanged")
}
