//
//  VehicleRepository.swift
//  GarageBook
//
//  The repository hides SwiftData from the ViewModel (same pattern as the course).
//

import Foundation
import SwiftData

// MARK: - Contract

@MainActor
protocol VehicleRepository {
    func fetchVehicles(query: String?, sort: VehicleSort) throws -> [Vehicle]  // Read
    func add(_ draft: VehicleDraft) throws                                      // Create
    func update(_ vehicle: Vehicle, with draft: VehicleDraft) throws            // Update
    func delete(_ vehicle: Vehicle) throws                                      // Delete
}

// MARK: - SwiftData implementation

@MainActor
final class SwiftDataVehicleRepository: VehicleRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchVehicles(query: String?, sort: VehicleSort) throws -> [Vehicle] {
        let term = (query ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        // Search name, make or model. nil predicate = fetch everything.
        var predicate: Predicate<Vehicle>?
        if !term.isEmpty {
            predicate = #Predicate<Vehicle> { vehicle in
                vehicle.name.localizedStandardContains(term) ||
                vehicle.make.localizedStandardContains(term) ||
                vehicle.model.localizedStandardContains(term)
            }
        }

        let descriptors: [SortDescriptor<Vehicle>]
        switch sort {
        case .nameAZ:
            descriptors = [SortDescriptor(\Vehicle.name)]
        case .newestAdded:
            descriptors = [SortDescriptor(\Vehicle.createdAt, order: .reverse)]
        case .newestYear:
            descriptors = [SortDescriptor(\Vehicle.year, order: .reverse),
                           SortDescriptor(\Vehicle.name)]
        case .highestMileage:
            descriptors = [SortDescriptor(\Vehicle.currentMileage, order: .reverse),
                           SortDescriptor(\Vehicle.name)]
        }

        return try context.fetch(FetchDescriptor<Vehicle>(predicate: predicate, sortBy: descriptors))
    }

    func add(_ draft: VehicleDraft) throws {
        let clean = try draft.validated()
        let vehicle = Vehicle(
            name: clean.name,
            make: clean.make,
            model: clean.model,
            year: clean.year,
            type: clean.type,
            currentMileage: clean.currentMileage,
            photoData: clean.photoData
        )
        context.insert(vehicle)
        try saveChanges()
    }

    func update(_ vehicle: Vehicle, with draft: VehicleDraft) throws {
        // Validate first, so a live model is never half-changed.
        let clean = try draft.validated()
        vehicle.name = clean.name
        vehicle.make = clean.make
        vehicle.model = clean.model
        vehicle.year = clean.year
        vehicle.type = clean.type
        vehicle.currentMileage = clean.currentMileage
        vehicle.photoData = clean.photoData
        try saveChanges()
    }

    func delete(_ vehicle: Vehicle) throws {
        context.delete(vehicle)   // its service records are deleted too (cascade rule)
        try saveChanges()
    }

    /// Save explicitly so failures can be reported; undo the change if it fails.
    /// (Autosave stays on because the whole app shares this context.)
    private func saveChanges() throws {
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
}
