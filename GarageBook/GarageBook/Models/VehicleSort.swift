//
//  VehicleSort.swift
//  GarageBook
//

import Foundation

/// How the vehicle list can be ordered.
enum VehicleSort: String, CaseIterable, Identifiable {
    case nameAZ
    case newestAdded
    case newestYear
    case highestMileage

    var id: String { rawValue }

    var label: String {
        switch self {
        case .nameAZ: "Name A–Z"
        case .newestAdded: "Recently added"
        case .newestYear: "Newest year"
        case .highestMileage: "Highest mileage"
        }
    }
}
