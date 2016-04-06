//
//  AppDelegate.swift
//  WhatColorIsIt
//
//  Created by Chris Slowik on 4/5/16.
//  Copyright © 2016 Chris Slowik. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let uDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    var timer: NSTimer!
    var appearance: String!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusItem.menu = statusMenu
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        appearance = uDefaults.stringForKey("AppleInterfaceStyle") ?? "Light"
        //uDefaults.addObserver(self, forKeyPath: "AppleInterfaceStyle", options: NSKeyValueObservingOptions.New, context: nil)
        
        
        updateTime()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        timer.invalidate()
        //uDefaults.removeObserver(self, forKeyPath: "AppleInterfaceStyle")
    }

    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    func updateTime() {
        statusItem.image = NSImage.whatColorIcon(appearance)
    }

}

extension NSColor {
    class func fromTime() -> NSColor {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second], fromDate: date)
        let rd = CGFloat(components.hour) / 24
        let grn = CGFloat(components.minute) / 60
        let bl = CGFloat(components.second) / 60
        return NSColor(red: rd, green: grn, blue: bl, alpha: 1)
    }
}

extension NSImage {
    class func whatColorIcon(appearance: String) -> NSImage {
        let theIcon = NSImage(size: NSSize(width: 16, height: 16))
        theIcon.lockFocus()
        let iconPath = NSBezierPath(roundedRect: NSMakeRect(0, 0, 14, 14), xRadius: 3, yRadius: 3)
        if appearance == "Dark" {
            NSColor(red:0.133, green:0.152, blue:0.182, alpha:0.5).setStroke()
        } else {
            NSColor(red:0.941, green:0.941, blue:0.941, alpha:0.5).setStroke()
        }
        NSColor.fromTime().setFill()
        iconPath.fill()
        iconPath.stroke()
        theIcon.unlockFocus()
        return theIcon
    }
}