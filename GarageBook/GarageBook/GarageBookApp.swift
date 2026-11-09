//
//  GarageBookApp.swift
//  GarageBook
//
//  Created by Elias Larhdaf on 2026-11-08.
//

import SwiftUI
import SwiftData

@main
struct GarageBookApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Vehicle.self,
            ServiceRecord.self,
            Part.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            #if DEBUG
            // Fake data on the first launch so screens aren't empty while we build them.
            SampleData.seedIfEmpty(container.mainContext)
            #endif
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
