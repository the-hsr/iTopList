//
//  DetailView.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import SwiftUI

struct DetailView: View {
    let app: AppEntry
    let showCloseButton: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingFullSummary = false
    
    var body: some View {
        VStack(spacing: 0) {
            if showCloseButton {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                    .keyboardShortcut(.escape, modifiers: [])
                    .help("Close (ESC)")
                }
                .padding()
            }

            ScrollView {
                VStack(spacing: 24) {
                    AppIconView(url: app.iconURL)
                        .frame(width: 120, height: 120)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)

                    Text(app.displayName)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)

                    Divider()
                        .frame(width: 200)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        Text(app.displaySummary)
                            .font(.body)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 24)
            }
        }
        .frame(minWidth: 400, minHeight: 500)
        .background(Color(NSColor.windowBackgroundColor))
    }
}
