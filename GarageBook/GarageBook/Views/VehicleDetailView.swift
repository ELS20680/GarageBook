//
//  VehicleDetailView.swift
//  GarageBook
//

import SwiftUI

/// Everything about one vehicle: info, totals and its latest services.
struct VehicleDetailView: View {
    let vehicle: Vehicle
    let vm: VehicleListViewModel

    @State private var editing = false

    /// The 5 most recent service records, newest first.
    private var recentRecords: [ServiceRecord] {
        Array(vehicle.serviceRecords.sorted { $0.date > $1.date }.prefix(5))
    }

    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    VehiclePhotoView(photoData: vehicle.photoData, type: vehicle.type, size: 80)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(vehicle.fullName).font(.title3.bold())
                        Text(vehicle.type.displayName).foregroundStyle(.secondary)
                    }
                }
            }

            Section("Overview") {
                LabeledContent("Mileage", value: "\(vehicle.currentMileage.formatted()) km")
                LabeledContent("Service records", value: "\(vehicle.serviceRecords.count)")
                LabeledContent("Total spent",
                               value: vehicle.totalSpent.formatted(.currency(code: "CAD")))
            }

            Section("Recent services") {
                if recentRecords.isEmpty {
                    Text("No service records yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(recentRecords) { record in
                        HStack {
                            Image(systemName: record.category.systemImage)
                                .frame(width: 28)
                                .foregroundStyle(.tint)
                            VStack(alignment: .leading) {
                                Text(record.title)
                                Text(record.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(record.cost.formatted(.currency(code: "CAD")))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(vehicle.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") { editing = true }
            }
        }
        .sheet(isPresented: $editing) {
            VehicleFormView(mode: .edit(vehicle)) { draft in
                try vm.update(vehicle, with: draft)
            }
        }
    }
}
