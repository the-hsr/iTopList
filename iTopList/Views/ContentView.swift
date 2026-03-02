//
//  ContentView.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: AppListViewModel

    var body: some View {
        VStack(spacing: 0) {
            searchAndToggleBar
                .padding()
                .background(Color(NSColor.controlBackgroundColor))

            contentArea
        }
        .frame(minWidth: 1000, minHeight: 600)
        .sheet(isPresented: Binding(
            get: { viewModel.isGrid && viewModel.showDetail },
            set: { if !$0 { viewModel.showDetail = false } }
        )) {
            if let app = viewModel.selectedApp {
                DetailView(app: app, showCloseButton: true)
            }
        }
    }

    private var searchAndToggleBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search apps...", text: $viewModel.searchText)
                    .textFieldStyle(.plain)
                    .disableAutocorrection(true)

                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )

            Picker("View Mode", selection: Binding(
                get: { viewModel.isGrid },
                set: { _ in viewModel.toggleGrid() }
            )) {
                Text("Column").tag(false)
                Text("Grid").tag(true)
            }
            .pickerStyle(.segmented)
            .frame(width: 200)
        }
    }

    @ViewBuilder
    private var contentArea: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .empty:
            emptyStateView
        case .loaded:
            if viewModel.isGrid {
                GalleryView()
                    .transition(.opacity)
                    .id(viewModel.isGrid)
            } else {
                ColumnView()
                    .transition(.opacity)
                    .id(viewModel.isGrid)
            }
        case .failed(let message):
            errorView(message)
        }
    }

    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .controlSize(.large)
            Text("Loading apps...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.stack.3d.up.slash")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text("No Apps Found")
                .font(.title2)
                .bold()
            Text("Try searching with different keywords")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            Text("Something Went Wrong")
                .font(.title2)
                .bold()
            Text(message)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                viewModel.refresh()
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
