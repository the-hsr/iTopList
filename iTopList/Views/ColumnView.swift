//
//  ColumnView.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import SwiftUI

struct ColumnView: View {
    @EnvironmentObject private var viewModel: AppListViewModel

    var body: some View {
        HSplitView {
            List(viewModel.visibleApps,
                 id: \.id,
                 selection: $viewModel.selectedApp) { app in
                AppRow(app: app)
                    .tag(app)
                    .onAppear {
                        viewModel.loadNextPageIfNeeded(currentItem: app)
                    }
                    .onTapGesture {
                        viewModel.selectApp(app, fromGrid: false)
                    }
            }
            .listStyle(.sidebar)
            .frame(minWidth: 280, idealWidth: 320, maxWidth: 400)

            Group {
                if let app = viewModel.selectedApp {
                    DetailView(app: app, showCloseButton: false)
                        .id(app.id)
                        .transition(.opacity)
                } else {
                    WelcomeView()
                        .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(NSColor.controlBackgroundColor))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
