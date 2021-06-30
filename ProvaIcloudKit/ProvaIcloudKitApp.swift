//
//  ProvaIcloudKitApp.swift
//  ProvaIcloudKit
//
//  Created by Michele Manniello on 30/06/21.
//

import SwiftUI

@main
struct ProvaIcloudKitApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
