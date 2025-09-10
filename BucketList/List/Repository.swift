//
//  Repository.swift
//  BucketList
//
//  Created by SUJOY on 07/09/25.
//

import SwiftData


protocol TaskRepositoryProtocol {
    func fetchTasks() -> [TaskItem]
    func addTask(_ task: TaskItem)
    func updateTask(_ task: TaskItem)
    func deleteTask(_ task: TaskItem)
}


struct SwiftDataTaskRepository: TaskRepositoryProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchTasks() -> [TaskItem] {
        let descriptor = FetchDescriptor<TaskItem>()
        return (try? context.fetch(descriptor)) ?? []
    }
    
    func addTask(_ task: TaskItem) {
        context.insert(task)
        try? context.save()
    }
    
    func updateTask(_ task: TaskItem) {
        try? context.save()
    }
    
    func deleteTask(_ task: TaskItem) {
        context.delete(task)
        try? context.save()
    }
}
