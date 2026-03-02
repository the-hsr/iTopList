//
//  AppListViewModel.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import SwiftUI
import Combine

@MainActor
final class AppListViewModel: ObservableObject {
    enum ViewState: Equatable {
        case loading
        case loaded
        case empty
        case failed(String)
    }

    @Published private(set) var state: ViewState = .loading
    @Published private(set) var visibleApps: [AppEntry] = []
    @Published var selectedApp: AppEntry?
    @Published var showDetail = false
    @Published var searchText = ""
    @Published var isGrid = false

    private let api: APIClientProtocol
    private var allApps: [AppEntry] = []
    private let pageSize = 20
    private var currentPage = 0
    private var isLoadingPage = false
    private var cancellables = Set<AnyCancellable>()

    private var filteredApps: [AppEntry] {
        guard !searchText.isEmpty else { return allApps }
        return allApps.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var totalFilteredCount: Int {
        filteredApps.count
    }

    init(api: APIClientProtocol) {
        self.api = api
        setupSearchDebounce()
    }

    static func makeDefault() -> AppListViewModel {
        AppListViewModel(api: APIClient())
    }

    func load() {
        Task {
            await fetchApps()
        }
    }

    func loadNextPageIfNeeded(currentItem: AppEntry) {
        guard let currentIndex = visibleApps.firstIndex(where: { $0.id == currentItem.id }) else {
            return
        }

        let thresholdIndex = visibleApps.count - 5
        guard currentIndex >= thresholdIndex else { return }

        loadNextPage()
    }

    func refresh() {
        currentPage = 0
        visibleApps.removeAll()
        load()
    }

    func applySearch() {
        resetPagination()
        loadNextPage()
    }

    func selectApp(_ app: AppEntry, fromGrid: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            self?.selectedApp = app

            self?.showDetail = fromGrid
        }
    }

    func toggleGrid() {
        DispatchQueue.main.async { [weak self] in
            self?.isGrid.toggle()
        }
    }

    private func fetchApps() async {
        do {
            await MainActor.run {
                state = .loading
            }

            let apps = try await api.fetchApps()

            await MainActor.run {
                allApps = apps
                resetPagination()

                if apps.isEmpty {
                    state = .empty
                } else {
                    state = .loaded
                    loadNextPage()
                }
            }
        } catch {
            await MainActor.run {
                handleError(error)
            }
        }
    }

    private func loadNextPage() {
        guard !isLoadingPage else { return }

        let startIndex = currentPage * pageSize
        let endIndex = min(startIndex + pageSize, totalFilteredCount)

        guard startIndex < endIndex else { return }

        isLoadingPage = true

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            let newItems = Array(self.filteredApps[startIndex..<endIndex])
            self.visibleApps.append(contentsOf: newItems)
            self.currentPage += 1
            self.isLoadingPage = false
        }
    }

    private func resetPagination() {
        visibleApps.removeAll()
        currentPage = 0
    }

    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            state = .failed(networkError.errorDescription ?? "Unknown error")
        } else {
            state = .failed(error.localizedDescription)
        }
    }

    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.applySearch()
            }
            .store(in: &cancellables)
    }
}
