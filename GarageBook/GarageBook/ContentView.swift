//
//  ContentView.swift
//  GarageBook
//
//  Temporary placeholder so the app runs on the new models.
//  It will be replaced by the real navigation (feature/app-navigation).
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Vehicle.name) private var vehicles: [Vehicle]

    var body: some View {
        NavigationStack {
            List(vehicles) { vehicle in
                VStack(alignment: .leading, spacing: 4) {
                    Text(vehicle.name).font(.headline)
                    Text(vehicle.fullName).font(.subheadline).foregroundStyle(.secondary)
                    Text("\(vehicle.serviceRecords.count) records · \(vehicle.totalSpent, format: .currency(code: "CAD")) spent")
                        .font(.caption)
                }
            }
            .navigationTitle("GarageBook")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.previewContainer)
}
