//
//  NSAlert+Fatal.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/24.
//

import Foundation
import AppKit

extension NSAlert {
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
    if promptRestart {
      if resp == .alertFirstButtonReturn {
        
      }
    }
    
    AppDelegate.shouldForceTermination = true
//    NSApp.relaun
  }
}
