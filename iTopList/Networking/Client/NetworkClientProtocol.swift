//
//  NetworkClientProtocol.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import Foundation

protocol NetworkClientProtocol: AnyObject {
    func fetch<T: APIRequest>(_ request: T) async throws -> T.Response
}
