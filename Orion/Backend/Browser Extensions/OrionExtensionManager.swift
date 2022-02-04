//
//  OrionExtensionManager.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/03.
//

import AppKit
import ZIPFoundation

class OrionExtensionManager {
  static let shared = OrionExtensionManager()

  let extensionDirectory = FileManager.default.applicationSupportUrl!
  var extensionManifests: [String: MozExtManifest] = [:]
  var loadedExtensions: [String] = []

  func loadAllExtensionData() {
    do {
      let extensions = try FileManager.default.contentsOfDirectory(
        atPath: FileManager.default.extensionDirectory!.path
      ).filter {
        return FileManager.default.directoryExists(
          atPath: FileManager.default.extensionDirectory!
              .appendingPathComponent($0).path
        )
      }

      for ext in extensions {
        let manifest: MozExtManifest? = OrionConfig.readJSON(
          withUrl: FileManager.default.extensionDirectory!
            .appendingPathComponent(ext)
            .appendingPathComponent("manifest.json"),
          convertFromSnakeCase: true)
        guard manifest != nil else { return }

        self.loadedExtensions.append(manifest!.name)
        self.extensionManifests[manifest!.name] = manifest
      }
    } catch {
      print("An error occurred loading all extensions: \(error)")

      let alert = NSAlert()
      alert.messageText = "Some error occurred"
      alert.informativeText = "We tried to enable all extensions but it failed!"
      alert.addButton(withTitle: "Ok")
      alert.runModal()
    }
  }

  func loadAllExtensions(toWindow window: NSWindow) {
    for ext in loadedExtensions {
      self.loadExtension(toWindow: window, self.extensionManifests[ext]!)
    }
  }

  func downloadExtension(withUrl url: URL) {
    print("Found download url for extension: \(url)")

    let name = NSString(
      string: URLComponents(
        url: url,
        resolvingAgainstBaseURL: false
      )!.path.components(separatedBy: "/").last!).deletingPathExtension

    do {
      let extensionData = try Data(contentsOf: url)
      if !FileManager.default.directoryExists(atPath: FileManager.default.extensionDirectory!.path) {
        try FileManager.default.createDirectory(
          at: FileManager.default.extensionDirectory!,
          withIntermediateDirectories: true
        )
      }

      try extensionData.write(to: FileManager.default.extensionDirectory!.appendingPathComponent("\(name).zip"))
      self.installExtension(withName: name)
    } catch {
      print("Error downloading extension: \(error)")

      let alert = NSAlert()
      alert.messageText = "Some error occurred"
      alert.informativeText = "We tried to download the extension but it failed! Please check your internet connection"
      alert.addButton(withTitle: "Ok")
      alert.runModal()
      return
    }
  }

  private func installExtension(withName name: String) {
    let extensionPackage = FileManager.default.extensionDirectory!.appendingPathComponent("\(name).zip")
    let extensionUnpackDest = FileManager.default.extensionDirectory!.appendingPathComponent("\(name)")
    do {
      try FileManager.default.createDirectory(
        at: extensionUnpackDest,
        withIntermediateDirectories: true,
        attributes: nil
      )
      try FileManager.default.unzipItem(at: extensionPackage, to: extensionUnpackDest)

      // Let's clean up before continuing...
      try FileManager.default.removeItem(at: extensionPackage)

      let manifest: MozExtManifest? =
        OrionConfig.readJSON(
          withUrl: extensionUnpackDest.appendingPathComponent("manifest.json"),
          convertFromSnakeCase: true
        )
      guard manifest != nil else { throw MozManifestError.missing }

      try FileManager.default.moveItem(
        at: extensionUnpackDest,
        to: FileManager.default.extensionDirectory!.appendingPathComponent(manifest!.name)
      )

      loadedExtensions.append(manifest!.name)
      self.loadExtension(toWindow: NSApp.keyWindow!, manifest!)
    } catch {
      print("Error installing extension: \(error)")

      let alert = NSAlert()
      alert.messageText = "Some error occurred"
      alert.informativeText = "We tried to install the extension but it failed!"
      alert.addButton(withTitle: "Ok")
      alert.runModal()

      return
    }
  }

  private func loadExtension(toWindow window: NSWindow, _ manifest: MozExtManifest) {
    window.toolbar!.insertItem(withItemIdentifier: .init("OrionExtension_\(manifest.name)"), at: 1)
  }
}
