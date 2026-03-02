//
//  GalleryView.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import SwiftUI

struct GalleryView: View {
    @EnvironmentObject private var viewModel: AppListViewModel

    private let columns = [
        GridItem(.adaptive(minimum: 120, maximum: 150), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.visibleApps) { app in
                    GalleryItemView(app: app)
                        .onTapGesture {
                            viewModel.selectApp(app, fromGrid: true)
                        }
                        .onAppear {
                            viewModel.loadNextPageIfNeeded(currentItem: app)
                        }
                }
            }
            .padding()
        }
    }
}
