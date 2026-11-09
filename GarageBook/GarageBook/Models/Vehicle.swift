//
//  Vehicle.swift
//  GarageBook
//

import Foundation
import SwiftData

@Model
final class Vehicle {
    var name: String          // nickname, e.g. "Daily Driver"
    var make: String
    var model: String
    var year: Int
    var type: VehicleType
    var currentMileage: Int   // in km
    @Attribute(.externalStorage) var photoData: Data?
    var createdAt: Date

    /// Deleting a vehicle also deletes its service records.
    @Relationship(deleteRule: .cascade, inverse: \ServiceRecord.vehicle)
    var serviceRecords: [ServiceRecord] = []

    init(
        name: String,
        make: String,
        model: String,
        year: Int,
        type: VehicleType = .car,
        currentMileage: Int = 0,
        photoData: Data? = nil,
        createdAt: Date = .now
    ) {
        self.name = name
        self.make = make
        self.model = model
        self.year = year
        self.type = type
        self.currentMileage = currentMileage
        self.photoData = photoData
        self.createdAt = createdAt
    }

    /// e.g. "2015 Honda Civic"
    var fullName: String {
        "\(year) \(make) \(model)"
    }

    /// Total of all service record costs for this vehicle.
    var totalSpent: Double {
        serviceRecords.reduce(0) { $0 + $1.cost }
    }
}
