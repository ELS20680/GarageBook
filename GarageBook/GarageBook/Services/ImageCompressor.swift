//
//  ImageCompressor.swift
//  GarageBook
//
//  Shrinks photos before they are stored, so the database stays small.
//  Reused later for invoice photos.
//

import UIKit

enum ImageCompressor {
    /// Returns JPEG data no larger than `maxDimension` points on its longest side.
    static func jpegData(from data: Data, maxDimension: CGFloat = 1024, quality: CGFloat = 0.7) -> Data? {
        guard let image = UIImage(data: data) else { return nil }

        let longestSide = max(image.size.width, image.size.height)
        let scale = longestSide > maxDimension ? maxDimension / longestSide : 1
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resized.jpegData(compressionQuality: quality)
    }
}
