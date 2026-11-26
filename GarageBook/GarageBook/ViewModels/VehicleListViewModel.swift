//
//  VehicleListViewModel.swift
//  GarageBook
//
//  Holds the state of the vehicle list screen and turns user actions
//  into repository calls. No SwiftUI code in here.
//

import Foundation
import Observation

@MainActor
@Observable
final class VehicleListViewModel {

    // MARK: - Screen state
    private(set) var items: [Vehicle] = []
    var query = ""
    var sort: VehicleSort = .nameAZ {
        didSet { if sort != oldValue { reload() } }
    }
    private(set) var errorMessage: String?

    @ObservationIgnored private let repo: any VehicleRepository

    init(repo: any VehicleRepository) {
        self.repo = repo
        reload()
    }

    // MARK: - Load and search

    func reload() {
        do {
            items = try repo.fetchVehicles(query: query, sort: sort)
            errorMessage = nil
        } catch {
            errorMessage = "Could not load vehicles: \(error.localizedDescription)"
        }
    }

    /// Called from `.task(id: query)`: waits 250 ms so we don't search on every keystroke.
    func searchAfterDebounce(for requestedQuery: String) async {
        do {
            if !requestedQuery.isEmpty { try await Task.sleep(for: .milliseconds(250)) }
            try Task.checkCancellation()
        } catch {
            return   // cancelled because the user kept typing
        }
        guard requestedQuery == query else { return }
        reload()
    }

    // MARK: - User actions

    /// add and update throw, so the form can show the error and keep what the user typed.
    func add(_ draft: VehicleDraft) throws {
        try repo.add(draft)
        reload()
    }

    func update(_ vehicle: Vehicle, with draft: VehicleDraft) throws {
        try repo.update(vehicle, with: draft)
        reload()
    }

    /// delete is called from the list (no form open), so it reports errors itself.
    func delete(_ vehicle: Vehicle) {
        do {
            try repo.delete(vehicle)
            reload()
        } catch {
            errorMessage = "Could not delete the vehicle: \(error.localizedDescription)"
        }
    }
}
