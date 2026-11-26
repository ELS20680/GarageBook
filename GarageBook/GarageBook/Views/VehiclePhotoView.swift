//
//  VehiclePhotoView.swift
//  GarageBook
//

import SwiftUI

/// Shows the vehicle's photo, or an icon for its type when there is no photo.
struct VehiclePhotoView: View {
    let photoData: Data?
    let type: VehicleType
    var size: CGFloat = 56

    var body: some View {
        Group {
            if let photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: type.systemImage)
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.quaternary)
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .accessibilityHidden(true)
    }
}
