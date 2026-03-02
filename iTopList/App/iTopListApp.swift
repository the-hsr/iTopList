//
//  iTopListApp.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//

import SwiftUI

@main
struct iTopApp: App {
    @StateObject private var viewModel = AppListViewModel.makeDefault()

    init() {
        configureAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .onAppear {
                    viewModel.load()
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
    }
    
    private func configureAppearance() {
        NSWindow.allowsAutomaticWindowTabbing = false
    }
}
