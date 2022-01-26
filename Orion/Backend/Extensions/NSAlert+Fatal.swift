//
//  NSAlert+Fatal.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/24.
//

import Foundation
import AppKit

extension NSAlert {
  /// Shows some error text and (optionally) prompts the user for a relaunch
  ///
  /// - Important: this function is **not** intended to return as it initiates a relaunch
  /// - SeeAlso: ``NSApplication/relaunch(_:)``
  func fatalError(informativeText text: String, promptRestart: Bool) {
    let alert = NSAlert()
    alert.alertStyle = .critical
    alert.messageText = "An Error Has Occured!"
    if promptRestart {
      alert.informativeText = "\(text)\nWould you like to restart?"
    } else {
      alert.informativeText = text
    }
    
    if promptRestart {
      alert.addButton(withTitle: "Yes").keyEquivalent = "\r"
      alert.addButton(withTitle: "Quit").keyEquivalent = ""
    } else {
      alert.addButton(withTitle: "Ok").keyEquivalent = ""
    }
    
    let resp = alert.runModal()
    AppDelegate.shouldForceTermination = true
    if promptRestart {
      if resp == .alertFirstButtonReturn {
        NSApp.relaunch(nil)
      }
    }
    
    NSApp.terminate(nil)
  }
}
