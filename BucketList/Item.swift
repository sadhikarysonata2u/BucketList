//
//  Item.swift
//  BucketList
//
//  Created by SUJOY on 05/09/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}


@Model
final class TaskItem {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    var priority: Priority
    var createdAt: Date
    
    enum Priority: Int, Codable, CaseIterable {
        case low = 0
        case medium = 1
        case high = 2
        
        var displayName: String {
            switch self {
            case .low: return "Low"
            case .medium: return "Medium"
            case .high: return "High"
            }
        }
        
        var color: String {
            switch self {
            case .low: return "green"
            case .medium: return "orange"
            case .high: return "red"
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        dueDate: Date? = nil,
        priority: Priority = .medium,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.priority = priority
        self.createdAt = createdAt
    }
}
