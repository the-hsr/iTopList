//
//  TopPaidAppsRequest.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import Foundation

struct TopPaidAppsRequest: APIRequest {
    typealias Response = RSSResponse

    var path: String = "/us/rss/toppaidapplications/limit=100/json"
    var cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad
}
