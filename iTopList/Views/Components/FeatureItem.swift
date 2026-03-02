//
//  FeatureItem.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import SwiftUI

struct FeatureItem: View {
    let icon: String
    let text: String

    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.accentColor.opacity(0.2), .accentColor.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(.accentColor)
                )

            Text(text)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}
