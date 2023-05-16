//
//  PowerConsumptionApp.swift
//  PowerConsumption
//
//  Created by Tommy on 2023/04/28.
//

import Charts
import IOKit
import SwiftUI

@main
struct PowerConsumptionApp: App {
    @NSApplicationDelegateAdaptor(CustomAppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            //it wont display anything anyway =w=
        }
    }
}

class CustomAppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        false
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // SwiftUI content view & a hosting view
        // Don't forget to set the frame, otherwise it won't be shown.
        //
        
        NSApp.setActivationPolicy(.accessory)
        
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
        
        // Status bar icon SwiftUI view & a hosting view.
        //
        
        let iconView = NSHostingView(rootView: someView())
        iconView.frame = NSRect(x: 0, y: 0, width: 40, height: 22)
        
        // Creating a menu item & the menu to add them later into the status bar
        //

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Exit", action: #selector(close), keyEquivalent: ""))
        
        // Adding content view to the status bar
        //
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.menu = menu
        
        // Adding the status bar icon
        //
        statusItem.button?.addSubview(iconView)
        statusItem.button?.frame = iconView.frame
        
        // StatusItem is stored as a property.
        self.statusItem = statusItem
    }
    
    @objc func close() -> Void {
        exit(0)
    }
}



class psuData: ObservableObject {
    @Published var current: Float = 0
    
    func getCurrent() -> Float {
        let res = getPowerInformation()
        return res
    }
}

struct someView: View {
    let timer = Timer.publish(every: 2, tolerance: 0.5, on: .main, in: .common).autoconnect()
    @State var p: Float = 0
    
    var body: some View {
        VStack {
            Text(String(format: "%.2fW", p))
                .font(.caption)
                .onReceive(timer, perform: {
                    _ in
                    
                    p = getPowerInformation()
                    
                })
        }.onDisappear(){
            timer.upstream.connect().cancel()
        }
        .onAppear(){
            p = getPowerInformation()
        }
    }
}
