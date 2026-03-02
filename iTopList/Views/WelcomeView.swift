//
//  WelcomeView.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "app.gift.fill")
                .font(.system(size: 80))
                .foregroundColor(.accentColor)

            Text("Welcome to iTopList")
                .font(.largeTitle)
                .bold()

            VStack(alignment: .center, spacing: 24) {
                Text("Discover the top 100 paid apps from the App Store")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)

                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 100))
                ], spacing: 16) {
                    FeatureItem(icon: "star.fill", text: "Top Charts")
                    FeatureItem(icon: "magnifyingglass", text: "Search")
                    FeatureItem(icon: "square.grid.2x2.fill", text: "Grid/Column")
                    FeatureItem(icon: "bolt.fill", text: "Fast & Cached")
                }
            }

            HStack {
                Image(systemName: "arrow.left")
                Text("Select an app from the list to get started")
                    .font(.headline)
            }
            .foregroundColor(.accentColor)
            .padding(.top, 20)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
