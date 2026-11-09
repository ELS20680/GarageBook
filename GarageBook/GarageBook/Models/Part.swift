//
//  Part.swift
//  GarageBook
//

import Foundation
import SwiftData

@Model
final class Part {
    var name: String
    var brand: String
    var partNumber: String
    var price: Double
    var quantity: Int

    var serviceRecord: ServiceRecord?

    init(
        name: String,
        brand: String = "",
        partNumber: String = "",
        price: Double = 0,
        quantity: Int = 1
    ) {
        self.name = name
        self.brand = brand
        self.partNumber = partNumber
        self.price = price
        self.quantity = quantity
    }
}
