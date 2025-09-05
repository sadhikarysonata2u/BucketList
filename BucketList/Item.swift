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
