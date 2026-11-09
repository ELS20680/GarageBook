//
//  ServiceCategory.swift
//  GarageBook
//

import Foundation

/// What kind of work a service record is about. Used for filters and charts.
enum ServiceCategory: String, Codable, CaseIterable, Identifiable {
    case oil
    case tires
    case brakes
    case fuel
    case mod
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .oil: return "Oil"
        case .tires: return "Tires"
        case .brakes: return "Brakes"
        case .fuel: return "Fuel"
        case .mod: return "Modification"
        case .other: return "Other"
        }
    }

    var systemImage: String {
        switch self {
        case .oil: return "drop.fill"
        case .tires: return "circle.circle"
        case .brakes: return "stop.circle"
        case .fuel: return "fuelpump.fill"
        case .mod: return "wrench.and.screwdriver.fill"
        case .other: return "ellipsis.circle"
        }
    }
}
