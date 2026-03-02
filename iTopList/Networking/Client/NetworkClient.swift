//
//  NetworkClient.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import Foundation

final class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let cache: DiskCache
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, 
         cache: DiskCache = .shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.cache = cache
        self.decoder = decoder
    }

    func fetch<T: APIRequest>(_ request: T) async throws -> T.Response {
        let urlRequest = try request.asURLRequest()

        do {
            let (data, response) = try await performRequest(urlRequest)
            try validateResponse(response)

            if let urlString = urlRequest.url?.absoluteString {
                cache.save(data: data, key: urlString)
            }

            return try decode(data)

        } catch {
            return try handleError(error, for: urlRequest, as: T.Response.self)
        }
    }

    private func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await session.data(for: request)
    }

    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }

        switch httpResponse.statusCode {
        case 200...299:
            return
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }

    private func decode<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }

    private func handleError<Response: Decodable>(_ error: Error, for request: URLRequest, as type: Response.Type) throws -> Response {
        if let urlString = request.url?.absoluteString,
           let cachedData = cache.load(key: urlString) {
            return try decode(cachedData) as Response
        }

        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                throw NetworkError.noInternetConnection
            case .timedOut:
                throw NetworkError.timeout
            default:
                throw NetworkError.unknown(urlError)
            }
        }

        throw NetworkError.unknown(error)
    }
}
