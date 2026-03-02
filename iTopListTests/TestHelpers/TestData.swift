//
//  TestData.swift
//  iTopListTests
//
//  Created by Himanshu Singh on 02/03/26.
//

import Foundation
@testable import iTopList

// MARK: - Test Data Helper
enum TestData {
    static func createMockApp(
        name: String = "Test App",
        summary: String = "Test Summary",
        iconURL: String = "https://test.com/icon.png"
    ) -> AppEntry {
        let json = """
        {
            "im:name": {"label": "\(name)"},
            "summary": {"label": "\(summary)"},
            "im:image": [
                {"label": "https://test.com/icon.png"},
                {"label": "\(iconURL)"}
            ]
        }
        """.data(using: .utf8)!
        
        return try! JSONDecoder().decode(AppEntry.self, from: json)
    }
    
    static func createMockApps(count: Int) -> [AppEntry] {
        var apps: [AppEntry] = []
        for i in 1...count {
            let app = createMockApp(
                name: "Test App \(i)",
                summary: "Summary \(i)",
                iconURL: "https://test.com/icon\(i).png"
            )
            apps.append(app)
        }
        return apps
    }
    
    static let mockRSSResponseJSON = """
    {
        "feed": {
            "entry": [
                {
                    "im:name": {"label": "Minecraft"},
                    "summary": {"label": "Dive into an open world of building, crafting and survival."},
                    "im:image": [
                        {"label": "https://test.com/minecraft.png"},
                        {"label": "https://test.com/minecraft@2x.png"}
                    ]
                },
                {
                    "im:name": {"label": "Geometry Dash"},
                    "summary": {"label": "Jump and fly your way through danger."},
                    "im:image": [
                        {"label": "https://test.com/geometry.png"},
                        {"label": "https://test.com/geometry@2x.png"}
                    ]
                }
            ]
        }
    }
    """
    
    static var mockRSSResponseData: Data {
        mockRSSResponseJSON.data(using: .utf8)!
    }
    
    static var mockRSSResponse: RSSResponse {
        try! JSONDecoder().decode(RSSResponse.self, from: mockRSSResponseData)
    }
}
