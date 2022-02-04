//
//  NSNotificationName+Orion.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/01.
//

import Foundation
import Cocoa

extension NSNotification.Name {
  static let WebViewChanged = NSNotification.Name("OrionControllerWebViewChanged")
  static let UserChangedTabLocation = NSNotification.Name("OrionCurrentTabLocationChangedViaUser")
  static let TabLocationChanged = NSNotification.Name("OrionCurrentTabLocationChanged")
}
