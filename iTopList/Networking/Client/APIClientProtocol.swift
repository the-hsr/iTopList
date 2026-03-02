//
//  APIClientProtocol.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import Foundation

protocol APIClientProtocol: AnyObject {
    func fetchApps() async throws -> [AppEntry]
}
