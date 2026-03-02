//
//  AppIconView.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import SwiftUI
import AppKit

struct AppIconView: View {
    let url: URL?
    @State private var image: NSImage?
    @State private var isLoading = false
    @State private var loadTask: Task<Void, Never>?

    var body: some View {
        Group {
            if let image = image {
                Image(nsImage: image)
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fit)
                    .transition(.opacity.combined(with: .scale))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))

                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.5)
                            .opacity(0.7)
                    } else {
                        Image(systemName: "app.dashed")
                            .font(.system(size: 24))
                            .foregroundColor(.gray.opacity(0.5))
                    }
                }
                .transition(.opacity)
            }
        }
        .frame(width: 60, height: 60)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onAppear {
            loadImage()
        }
        .onDisappear {
            loadTask?.cancel()
        }
        .onChange(of: url) { _, _ in
            loadImage()
        }
    }

    private func loadImage() {
        loadTask?.cancel()

        guard let url = url else {
            image = nil
            return
        }

        isLoading = true

        loadTask = Task {
            try? await Task.sleep(nanoseconds: 50_000_000)

            guard !Task.isCancelled else { return }

            let loadedImage = await ImageLoader.shared.loadImage(from: url)

            await MainActor.run {
                guard !Task.isCancelled else { return }
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.image = loadedImage
                    self.isLoading = false
                }
            }
        }
    }
}
