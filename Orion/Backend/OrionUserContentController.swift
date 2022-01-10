//
//  OrionUserContentController.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/02.
//

import Cocoa
import WebKit

class OrionUserContentController: WKUserContentController {
  init(scriptNames: [String]) {
      super.init()
      for name in scriptNames {
          self.addUserScript(WKUserScript(name: name))
      }
  }

  required init?(coder: NSCoder) {
      super.init(coder: coder)
  }
}
