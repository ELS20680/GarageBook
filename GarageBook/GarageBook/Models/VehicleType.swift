//
//  VehicleType.swift
//  GarageBook
//

import Foundation

/// The kind of vehicle the user owns.
enum VehicleType: String, Codable, CaseIterable, Identifiable {
    case car
    case motorcycle

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .car: return "Car"
        case .motorcycle: return "Motorcycle"
        }
    }

    var systemImage: String {
        switch self {
        case .car: return "car.fill"
        case .motorcycle: return "scooter"
        }
    }
}
