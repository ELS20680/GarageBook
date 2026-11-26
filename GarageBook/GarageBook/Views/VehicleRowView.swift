//
//  VehicleRowView.swift
//  GarageBook
//

import SwiftUI

/// One row of the vehicle list.
struct VehicleRowView: View {
    let vehicle: Vehicle

    var body: some View {
        HStack(spacing: 12) {
            VehiclePhotoView(photoData: vehicle.photoData, type: vehicle.type, size: 56)

            VStack(alignment: .leading, spacing: 2) {
                Text(vehicle.name)
                    .font(.headline)
                Text(vehicle.fullName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("\(vehicle.currentMileage.formatted()) km · \(vehicle.serviceRecords.count) records")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}
