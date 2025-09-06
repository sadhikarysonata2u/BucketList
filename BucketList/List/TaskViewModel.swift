//
//  TaskViewModel.swift
//  BucketList
//
//  Created by SUJOY on 05/09/25.
//

import SwiftData
import Foundation

@MainActor
class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    @Published var newTaskTitle = ""
    @Published var newTaskDueDate = Date()
    @Published var newTaskPriority: TaskItem.Priority = .medium
    @Published var showAddTask = false
    @Published var sortOption: SortOption = .createdDate
    @Published var filterOption: FilterOption = .all
    
    private let modelContext: ModelContext
    
    enum SortOption: String, CaseIterable {
        case createdDate = "Created Date"
        case dueDate = "Due Date"
        case priority = "Priority"
        case title = "Title"
    }
    
    enum FilterOption: String, CaseIterable {
        case all = "All"
        case completed = "Completed"
        case pending = "Pending"
        case highPriority = "High Priority"
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchTasks()
    }
    
    func fetchTasks() {
        let descriptor = FetchDescriptor<TaskItem>()
        do {
            tasks = try modelContext.fetch(descriptor)
            sortTasks()
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }
    
    func addTask() {
        guard !newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let task = TaskItem(
            title: newTaskTitle,
            dueDate: newTaskDueDate,
            priority: newTaskPriority
        )
        
        modelContext.insert(task)
        
        do {
            try modelContext.save()
            fetchTasks()
            resetForm()
            showAddTask = false
        } catch {
            print("Failed to save task: \(error)")
        }
    }
    
    func toggleTaskCompletion(_ task: TaskItem) {
        task.isCompleted.toggle()
        saveContext()
    }
    
    func deleteTask(_ task: TaskItem) {
        modelContext.delete(task)
        saveContext()
    }
    
    func updateTask(_ task: TaskItem, title: String, dueDate: Date?, priority: TaskItem.Priority) {
        task.title = title
        task.dueDate = dueDate
        task.priority = priority
        saveContext()
    }
    
    func sortTasks() {
        switch sortOption {
        case .createdDate:
            tasks.sort { $0.createdAt > $1.createdAt }
        case .dueDate:
            tasks.sort {
                guard let date1 = $0.dueDate, let date2 = $1.dueDate else { return false }
                return date1 < date2
            }
        case .priority:
            tasks.sort { $0.priority.rawValue > $1.priority.rawValue }
        case .title:
            tasks.sort { $0.title.localizedCompare($1.title) == .orderedAscending }
        }
    }
    
    func filterTasks() -> [TaskItem] {
        switch filterOption {
        case .all:
            return tasks
        case .completed:
            return tasks.filter { $0.isCompleted }
        case .pending:
            return tasks.filter { !$0.isCompleted }
        case .highPriority:
            return tasks.filter { $0.priority == .high }
        }
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
            fetchTasks()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    private func resetForm() {
        newTaskTitle = ""
        newTaskDueDate = Date()
        newTaskPriority = .medium
    }
}
