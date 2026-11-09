//
//  ServiceRecord.swift
//  GarageBook
//

import Foundation
import SwiftData

@Model
final class ServiceRecord {
    var title: String
    var category: ServiceCategory
    var date: Date
    var mileage: Int
    /// Total cost of the service, parts included (parts below are only the itemized detail).
    var cost: Double
    var notes: String
    @Attribute(.externalStorage) var receiptPhotoData: Data?

    // Used by reminders. Either one (or both) can be set.
    var nextServiceDate: Date?
    var nextServiceMileage: Int?

    var vehicle: Vehicle?

    /// Deleting a record also deletes its parts.
    @Relationship(deleteRule: .cascade, inverse: \Part.serviceRecord)
    var parts: [Part] = []

    init(
        title: String,
        category: ServiceCategory = .other,
        date: Date = .now,
        mileage: Int = 0,
        cost: Double = 0,
        notes: String = "",
        receiptPhotoData: Data? = nil,
        nextServiceDate: Date? = nil,
        nextServiceMileage: Int? = nil
    ) {
        self.title = title
        self.category = category
        self.date = date
        self.mileage = mileage
        self.cost = cost
        self.notes = notes
        self.receiptPhotoData = receiptPhotoData
        self.nextServiceDate = nextServiceDate
        self.nextServiceMileage = nextServiceMileage
    }
}
