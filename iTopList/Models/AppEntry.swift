//
//  AppEntry.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import Foundation

struct AppEntry: Decodable, Identifiable, Hashable {
    let id = UUID()
    let name: Label
    let summary: Label
    let images: [ImageData]

    enum CodingKeys: String, CodingKey {
        case name = "im:name"
        case summary
        case images = "im:image"
    }

    var iconURL: URL? {
        images.last?.label
    }

    var displayName: String {
        name.label
    }

    var displaySummary: String {
        summary.label
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: AppEntry, rhs: AppEntry) -> Bool {
        lhs.id == rhs.id
    }
}
