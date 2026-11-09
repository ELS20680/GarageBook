//
//  VehicleListView.swift
//  GarageBook
//
//  The vehicles screen: search, sort, list, add/edit sheets, delete.
//  The View shows state and forwards actions to the ViewModel. No database code here.
//

import SwiftUI
import SwiftData

@MainActor
struct VehicleListView: View {
    @State private var vm: VehicleListViewModel
    @State private var presentingAdd = false
    @State private var editingVehicle: Vehicle?
    @State private var vehicleToDelete: Vehicle?

    init(context: ModelContext) {
        _vm = State(initialValue: VehicleListViewModel(
            repo: SwiftDataVehicleRepository(context: context)
        ))
    }

    var body: some View {
        @Bindable var model = vm

        NavigationStack {
            List {
                if let message = model.errorMessage {
                    Text(message).foregroundStyle(.red)
                }

                ForEach(model.items) { vehicle in
                    NavigationLink(value: vehicle) {
                        VehicleRowView(vehicle: vehicle)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            vehicleToDelete = vehicle
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        Button {
                            editingVehicle = vehicle
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .navigationTitle("Garage")
            .navigationDestination(for: Vehicle.self) { vehicle in
                VehicleDetailView(vehicle: vehicle, vm: vm)
            }
            .searchable(text: $model.query, prompt: "Search name, make or model")
            .task(id: model.query) {
                await model.searchAfterDebounce(for: model.query)
            }
            .overlay { emptyState }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { sortMenu }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { presentingAdd = true } label: {
                        Label("Add Vehicle", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $presentingAdd) {
                VehicleFormView(mode: .add) { draft in
                    try vm.add(draft)
                }
            }
            .sheet(item: $editingVehicle) { vehicle in
                VehicleFormView(mode: .edit(vehicle)) { draft in
                    try vm.update(vehicle, with: draft)
                }
            }
            .confirmationDialog(
                "Delete this vehicle?",
                isPresented: Binding(
                    get: { vehicleToDelete != nil },
                    set: { if !$0 { vehicleToDelete = nil } }
                ),
                titleVisibility: .visible,
                presenting: vehicleToDelete
            ) { vehicle in
                Button("Delete \(vehicle.name)", role: .destructive) {
                    vm.delete(vehicle)
                }
            } message: { vehicle in
                Text("Its \(vehicle.serviceRecords.count) service records will be deleted too.")
            }
        }
    }

    // MARK: - Pieces

    private var sortMenu: some View {
        Menu {
            Picker("Sort vehicles", selection: Bindable(vm).sort) {
                ForEach(VehicleSort.allCases) { sort in
                    Text(sort.label).tag(sort)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
        .accessibilityValue(vm.sort.label)
    }

    /// Shown on top of the list when there is nothing to display.
    @ViewBuilder
    private var emptyState: some View {
        if vm.items.isEmpty && vm.errorMessage == nil {
            if vm.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ContentUnavailableView(
                    "No vehicles yet",
                    systemImage: "car.fill",
                    description: Text("Tap + to add your first vehicle.")
                )
            } else {
                ContentUnavailableView.search(text: vm.query)
            }
        }
    }
}
