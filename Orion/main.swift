//
//  main.swift
//  Orion
//
//  Created by Jules Amalie on 2021/12/31.
//

import Cocoa

let delegate = AppDelegate()
// using `.shared` initialises the app for us
NSApplication.shared.delegate = delegate
NSApplication.shared.mainMenu = OrionMenu()
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
