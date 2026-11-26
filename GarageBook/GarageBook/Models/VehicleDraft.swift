//
//  VehicleDraft.swift
//  GarageBook
//

import Foundation

/// Why a vehicle could not be saved. Shown to the user inside the form.
enum VehicleError: LocalizedError {
    case missingName
    case missingMake
    case missingModel
    case invalidYear
    case negativeMileage

    var errorDescription: String? {
        switch self {
        case .missingName: "Please give the vehicle a name."
        case .missingMake: "Please enter the make (for example Honda)."
        case .missingModel: "Please enter the model (for example Civic)."
        case .invalidYear: "Please enter a valid year."
        case .negativeMileage: "Mileage cannot be negative."
        }
    }
}

/// A plain copy of the editable vehicle fields.
/// The form edits this copy, so a live Vehicle is only changed when the user taps Save.
struct VehicleDraft {
    var name = ""
    var make = ""
    var model = ""
    var year = Calendar.current.component(.year, from: .now)
    var type: VehicleType = .car
    var currentMileage = 0
    var photoData: Data?

    init() {}

    init(vehicle: Vehicle) {
        name = vehicle.name
        make = vehicle.make
        model = vehicle.model
        year = vehicle.year
        type = vehicle.type
        currentMileage = vehicle.currentMileage
        photoData = vehicle.photoData
    }

    /// Latest year we accept (next year's models exist already).
    static var maxYear: Int {
        Calendar.current.component(.year, from: .now) + 1
    }

    /// Single source of truth for the rules. Returns a trimmed copy or throws.
    func validated() throws -> VehicleDraft {
        var clean = self
        clean.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        clean.make = make.trimmingCharacters(in: .whitespacesAndNewlines)
        clean.model = model.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !clean.name.isEmpty else { throw VehicleError.missingName }
        guard !clean.make.isEmpty else { throw VehicleError.missingMake }
        guard !clean.model.isEmpty else { throw VehicleError.missingModel }
        guard (1900...Self.maxYear).contains(clean.year) else { throw VehicleError.invalidYear }
        guard clean.currentMileage >= 0 else { throw VehicleError.negativeMileage }
        return clean
    }

    /// Used to enable or disable the Save button.
    var isValid: Bool {
        (try? validated()) != nil
    }
}
