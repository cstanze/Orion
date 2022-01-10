//
//  OrionErrors.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/07.
//

import Foundation

enum MozManifestError: Error {
  case missing
  case malformed
}

extension MozManifestError: CustomStringConvertible {
  public var description: String {
    switch self {
    case .missing:
      return "Couldn't find any mozilla extension manifest"
    case .malformed:
      return "Found a malformed mozilla extension manifest"
    }
  }
}
