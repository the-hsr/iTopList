//
//  GalleryItemView.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import SwiftUI

struct GalleryItemView: View {
    let app: AppEntry

    var body: some View {
        VStack(spacing: 8) {
            AppIconView(url: app.iconURL)
                .frame(width: 80, height: 80)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)

            Text(app.displayName)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 100)
        }
        .frame(width: 120)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}
