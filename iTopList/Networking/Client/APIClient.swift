//
//  APIClient.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import Foundation

final class APIClient: APIClientProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchApps() async throws -> [AppEntry] {
        let request = TopPaidAppsRequest()
        let response = try await networkClient.fetch(request)
        return response.feed.entry
    }
}
