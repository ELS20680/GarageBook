//
//  SampleData.swift
//  GarageBook
//
//  Fake data so everyone can build and test screens without waiting on each other.
//

import Foundation
import SwiftData

@MainActor
enum SampleData {

    /// In-memory container filled with sample data, for SwiftUI previews.
    static var previewContainer: ModelContainer {
        do {
            let container = try ModelContainer(
                for: Vehicle.self, ServiceRecord.self, Part.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            insert(into: container.mainContext)
            return container
        } catch {
            fatalError("Could not create preview container: \(error)")
        }
    }

    /// Adds the sample data only when the store has no vehicles yet.
    static func seedIfEmpty(_ context: ModelContext) {
        let count = (try? context.fetchCount(FetchDescriptor<Vehicle>())) ?? 0
        if count == 0 {
            insert(into: context)
        }
    }

    /// Inserts 2 vehicles with a few months of service history.
    static func insert(into context: ModelContext) {
        let civic = Vehicle(name: "Daily Driver", make: "Honda", model: "Civic",
                            year: 2015, type: .car, currentMileage: 98_500)
        let bike = Vehicle(name: "Weekend Bike", make: "Yamaha", model: "MT-07",
                           year: 2018, type: .motorcycle, currentMileage: 24_300)
        context.insert(civic)
        context.insert(bike)

        @discardableResult
        func addRecord(
            _ title: String, _ category: ServiceCategory, to vehicle: Vehicle,
            daysAgo: Int, mileage: Int, cost: Double, notes: String = "",
            nextInDays: Int? = nil, nextMileage: Int? = nil
        ) -> ServiceRecord {
            let record = ServiceRecord(
                title: title,
                category: category,
                date: date(daysAgo: daysAgo),
                mileage: mileage,
                cost: cost,
                notes: notes,
                nextServiceDate: nextInDays.map { date(daysAgo: -$0) },
                nextServiceMileage: nextMileage
            )
            context.insert(record)
            record.vehicle = vehicle
            return record
        }

        func addPart(_ name: String, brand: String, price: Double, quantity: Int = 1, to record: ServiceRecord) {
            let part = Part(name: name, brand: brand, price: price, quantity: quantity)
            context.insert(part)
            part.serviceRecord = record
        }

        // Civic
        let oil = addRecord("Oil and filter change", .oil, to: civic, daysAgo: 40,
                            mileage: 96_800, cost: 89.99, notes: "5W-30 synthetic",
                            nextInDays: 140, nextMileage: 104_800)
        addPart("Oil filter", brand: "Fram", price: 12.99, to: oil)
        addPart("Synthetic oil 5W-30 (4 L)", brand: "Mobil 1", price: 42.00, to: oil)

        let brakes = addRecord("Front brake pads", .brakes, to: civic, daysAgo: 120,
                               mileage: 93_200, cost: 245.50)
        addPart("Front brake pads", brand: "Akebono", price: 78.00, to: brakes)

        addRecord("Winter tires installed", .tires, to: civic, daysAgo: 20,
                  mileage: 97_900, cost: 120.00, notes: "Swap + balancing")
        addRecord("Fuel", .fuel, to: civic, daysAgo: 6, mileage: 98_300, cost: 64.20)
        addRecord("Fuel", .fuel, to: civic, daysAgo: 35, mileage: 97_000, cost: 58.75)
        addRecord("Cabin air filter", .other, to: civic, daysAgo: 200,
                  mileage: 90_100, cost: 35.00)

        // Bike
        let chain = addRecord("Chain and sprocket kit", .other, to: bike, daysAgo: 75,
                              mileage: 23_000, cost: 310.00,
                              nextInDays: 300, nextMileage: 32_000)
        addPart("Chain", brand: "DID", price: 130.00, to: chain)
        addPart("Sprocket set", brand: "JT", price: 95.00, to: chain)

        addRecord("Oil change", .oil, to: bike, daysAgo: 60, mileage: 23_400, cost: 74.00,
                  nextInDays: 120, nextMileage: 27_400)
        addRecord("Slip-on exhaust", .mod, to: bike, daysAgo: 150, mileage: 21_800, cost: 480.00)
        addRecord("Fuel", .fuel, to: bike, daysAgo: 10, mileage: 24_100, cost: 22.40)
    }

    private static func date(daysAgo: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -daysAgo, to: .now) ?? .now
    }
}
