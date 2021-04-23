//
//  Swif_T_ScoreApp.swift
//  Swif-T-Score
//
//  Created by Steven Brown on 23/04/21.
//

import SwiftUI

@main
struct Swif_T_ScoreApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
