//
//  RSSResponse.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import Foundation

struct RSSResponse: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let entry: [AppEntry]
}
