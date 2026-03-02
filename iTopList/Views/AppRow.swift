//
//  AppRow.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import SwiftUI

struct AppRow: View {
    let app: AppEntry

    var body: some View {
        HStack(spacing: 12) {
            AppIconView(url: app.iconURL)
                .frame(width: 48, height: 48)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(app.displayName)
                    .font(.headline)
                    .lineLimit(1)

                Text(app.displaySummary)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
