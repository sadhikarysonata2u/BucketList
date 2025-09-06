//
//  BucketListApp.swift
//  BucketList
//
//  Created by SUJOY on 05/09/25.
//

import SwiftUI
import SwiftData

//@main
//struct BucketListApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//            TaskItem.self
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//        .modelContainer(sharedModelContainer)
//    }
//}
import SwiftUI
import SwiftData

@main
struct TaskApp: App {
    var body: some Scene {
        WindowGroup {
            TasksView()
        }
        .modelContainer(TaskItem.container)
    }
}

extension TaskItem {
    static var container: ModelContainer {
        let schema = Schema([TaskItem.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
