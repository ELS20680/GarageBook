//
//  VehicleFormView.swift
//  GarageBook
//
//  The Add / Edit sheet. It edits a copy (VehicleDraft) and hands it to onSave.
//

import SwiftUI
import PhotosUI

struct VehicleFormView: View {
    enum Mode {
        case add
        case edit(Vehicle)
    }

    private let mode: Mode
    /// Called when Save is tapped. It throws, so a failed save comes back to this form.
    private let onSave: (VehicleDraft) throws -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var draft: VehicleDraft
    @State private var pickerItem: PhotosPickerItem?
    @State private var saveError: String?

    init(mode: Mode, onSave: @escaping (VehicleDraft) throws -> Void) {
        self.mode = mode
        self.onSave = onSave
        switch mode {
        case .add:
            _draft = State(initialValue: VehicleDraft())
        case .edit(let vehicle):
            _draft = State(initialValue: VehicleDraft(vehicle: vehicle))
        }
    }

    private var title: String {
        switch mode {
        case .add: "New Vehicle"
        case .edit: "Edit Vehicle"
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Photo") {
                    HStack(spacing: 16) {
                        VehiclePhotoView(photoData: draft.photoData, type: draft.type, size: 80)
                        VStack(alignment: .leading, spacing: 8) {
                            PhotosPicker(selection: $pickerItem, matching: .images) {
                                Label(draft.photoData == nil ? "Choose photo" : "Change photo",
                                      systemImage: "photo")
                            }
                            if draft.photoData != nil {
                                Button("Remove photo", role: .destructive) {
                                    draft.photoData = nil
                                    pickerItem = nil
                                }
                            }
                        }
                    }
                }

                Section("Vehicle") {
                    Picker("Type", selection: $draft.type) {
                        ForEach(VehicleType.allCases) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)

                    TextField("Name (e.g. Daily Driver)", text: $draft.name)
                    TextField("Make (e.g. Honda)", text: $draft.make)
                    TextField("Model (e.g. Civic)", text: $draft.model)
                    TextField("Year", value: $draft.year, format: .number.grouping(.never))
                        .keyboardType(.numberPad)
                    TextField("Mileage (km)", value: $draft.currentMileage, format: .number.grouping(.never))
                        .keyboardType(.numberPad)
                }

                if let saveError {
                    Section("Could not save") {
                        Text(saveError).foregroundStyle(.red)
                        Text("Your changes are still here. Fix the problem and tap Save again.")
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(!draft.isValid)
                }
            }
            .onChange(of: pickerItem) { _, newItem in
                loadPhoto(from: newItem)
            }
        }
    }

    private func save() {
        do {
            try onSave(draft)
            dismiss()   // only after the save worked
        } catch {
            saveError = error.localizedDescription
        }
    }

    /// Loads the chosen photo in the background, then stores a smaller version.
    private func loadPhoto(from item: PhotosPickerItem?) {
        guard let item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let small = ImageCompressor.jpegData(from: data) {
                draft.photoData = small
            }
        }
    }
}
