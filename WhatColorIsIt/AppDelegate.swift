//
//  AppDelegate.swift
//  WhatColorIsIt
//
//  Created by Chris Slowik on 4/5/16.
//  Copyright © 2016 Chris Slowik. All rights reserved.
//

import Cocoa

enum ColorSpace: Int {
    case RGB    = 0
    case HSB    = 1
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let uDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var hsbItem: NSMenuItem!
    @IBOutlet weak var rgbItem: NSMenuItem!
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    var timer: NSTimer!
    var appearance: String!
    var colorSpace: ColorSpace = ColorSpace.RGB

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusItem.menu = statusMenu
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        appearance = uDefaults.stringForKey("AppleInterfaceStyle") ?? "Light"
        uDefaults.addObserver(self, forKeyPath: "AppleInterfaceStyle", options: NSKeyValueObservingOptions.New, context: nil)
        
        updateTime()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        timer.invalidate()
        uDefaults.removeObserver(self, forKeyPath: "AppleInterfaceStyle")
    }

    
    @IBAction func rgbClicked(sender: AnyObject) {
        colorSpace = ColorSpace.RGB
        rgbItem.state = NSOnState
        hsbItem.state = NSOffState
    }
    
    @IBAction func labClicked(sender: AnyObject) {
        colorSpace = ColorSpace.HSB
        hsbItem.state = NSOnState
        rgbItem.state = NSOffState
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    func updateTime() {
        statusItem.image = NSImage.whatColorIcon(appearance, colorSpace: colorSpace)
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        print(keyPath)
    }
}

extension NSColor {
    class func fromTimeRGB() -> NSColor {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second], fromDate: date)
        let rd = CGFloat(components.hour) / 24
        let grn = CGFloat(components.minute) / 60
        let bl = CGFloat(components.second) / 60
        return NSColor(red: rd, green: grn, blue: bl, alpha: 1)
    }
    
    class func fromTimeHSB() -> NSColor {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second], fromDate: date)
        let H = CGFloat(components.hour) / 24
        let S = CGFloat(components.minute) / 60
        let B = max((CGFloat(components.second) / 60), 0.1)
        return NSColor(calibratedHue: H, saturation: S, brightness: B, alpha: 1.0)
    }
}

extension NSImage {
    class func whatColorIcon(appearance: String, colorSpace: ColorSpace) -> NSImage {
        let theIcon = NSImage(size: NSSize(width: 14, height: 14))
        theIcon.lockFocus()
        let iconPath = NSBezierPath(roundedRect: NSMakeRect(0, 0, 14, 14), xRadius: 3, yRadius: 3)
        if appearance == "Dark" {
            NSColor(red:0.133, green:0.152, blue:0.182, alpha:0.5).setStroke()
        } else {
            NSColor(red:0.941, green:0.941, blue:0.941, alpha:0.5).setStroke()
        }
        switch colorSpace {
        case .RGB:
            NSColor.fromTimeRGB().setFill()
            break
        case .HSB:
            NSColor.fromTimeHSB().setFill()
            break
        default:
            break
        }
        iconPath.fill()
        iconPath.stroke()
        theIcon.unlockFocus()
        return theIcon
    }
}