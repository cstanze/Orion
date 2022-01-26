//
//  NSApplication+Relaunch.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/25.
//

import Foundation
import Cocoa

extension NSApplication {
  /// Relaunches the current application using the `OrionRelaunchHelper`
  ///
  /// - Parameter sender: Typically, this parameter contains the object that initiated the relaunch request.
  ///
  /// - Important: this function is **not** intended to return as it runs the relaunch script and kills the application
  func relaunch(_ sender: AnyObject?) {
    let task = Process()
    task.launchPath = Bundle.main.path(forResource: "OrionRelaunchHelper", ofType: nil)!
    task.arguments = [String(ProcessInfo.processInfo.processIdentifier)]
    task.launch()
  }
}
