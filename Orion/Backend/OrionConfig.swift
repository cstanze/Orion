//
//  OrionConfig.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/03.
//

import CoreFoundation
import Foundation

class OrionConfig {
  /// Reads arbitrary JSON
  static func readJSON<D: Decodable>(withUrl url: URL, convertFromSnakeCase: Bool) -> D? {
    if !FileManager.default.fileExists(atPath: url.path) {
      return nil
    } else {
      do {
        let jsonData = try Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        if convertFromSnakeCase {
          jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        }
        
        return try jsonDecoder.decode(D.self, from: jsonData)
      } catch {
        print("Error occurred retrieving config: \(error)")
        return nil
      }
    }
  }
  
  /// Writes arbitrary JSON
  static func writeJSON<E: Encodable>(withUrl url: URL, data: E, convertToSnakeCase: Bool) {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted /// Helps when debugging...
    if convertToSnakeCase {
      jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
    }
    do {
      let jsonData = try jsonEncoder.encode(data)
      if !FileManager.default.fileExists(atPath: url.path) {
        FileManager.default.createFile(atPath: url.path, contents: jsonData, attributes: nil)
      } else {
        /// By default, remove file protection on arbitrary writes
        try jsonData.write(to: url, options: [.atomic])
      }
    } catch {
      print("Error occurred saving config: \(error)")
    }
  }
  
  /// Inserts any encodable object into a JSON config file.
  static func writeToConfig<E: Encodable>(named name: String, data: E) {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted /// Helps when debugging...
    do {
      let jsonData = try jsonEncoder.encode(data)
      let configPath = FileManager.default.applicationSupportUrl!.appendingPathComponent("\(name).json")
      if !FileManager.default.fileExists(atPath: configPath.path) {
        FileManager.default.createFile(atPath: configPath.path, contents: jsonData, attributes: nil)
      } else {
        if #available(macOS 11, *) {
          try jsonData.write(to: configPath, options: [.atomic, .completeFileProtection])
        } else {
          /// Sad, no file protection below macOS 11 :(
          try jsonData.write(to: configPath, options: [.atomic])
        }
      }
    } catch {
      print("Error occurred saving config: \(error)")
    }
  }
  
  /// Gets the contents of a JSON config file and decodes it
  static func getFromConfig<D: Decodable>(named name: String) -> D? {
    let configPath = FileManager.default.applicationSupportUrl!.appendingPathComponent("\(name).json")
    if !FileManager.default.fileExists(atPath: configPath.path) {
      FileManager.default.createFile(atPath: configPath.path, contents: "".data(using: .utf8), attributes: nil)
      return getFromConfig(named: name)
    } else {
      do {
        let jsonData = try Data(contentsOf: configPath)
        let jsonDecoder = JSONDecoder()
        
        return try jsonDecoder.decode(D.self, from: jsonData)
      } catch {
        print("Error occurred retrieving config: \(error)")
        return nil
      }
    }
  }
}
