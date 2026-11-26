//
//  ContentView.swift
//  GarageBook
//
//  Root view. For now it shows the vehicle list; the final tab navigation
//  (feature/app-navigation) will replace this.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VehicleListView(context: modelContext)
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.previewContainer)
}
