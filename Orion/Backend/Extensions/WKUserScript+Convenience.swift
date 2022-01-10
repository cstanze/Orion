//
//  WKUserScript+Convenience.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/02.
//

import WebKit

extension WKUserScript {
    
  convenience init(name: String) {
    self.init(source: WKUserScript.ensureInternalResource(withName: name), injectionTime: .atDocumentEnd, forMainFrameOnly: true)
  }

  static func ensureInternalResource(withName name: String) -> String {
    var sourceCode: String? = WKUserScript.loadJavascript(withName: name)
    if sourceCode == nil {
      sourceCode = "console.error('Failed to load internal resource \(name)')"
    }
    return sourceCode!
  }
    
  static func loadJavascript(withName name: String) -> String? {
    if let path = Bundle.main.path(forResource: name, ofType: "js") {
      print(path)
      do {
        let sourceCode: String = try String(contentsOfFile: path)
        return sourceCode
      } catch {
        print("Couldn't load javascript resource: \(error)")
        return nil
      }
    } else {
      print("Couldn't find resource in bundle")
      return nil
    }
  }

}
