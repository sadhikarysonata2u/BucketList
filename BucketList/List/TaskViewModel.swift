//
//  TaskViewModel.swift
//  BucketList
//
//  Created by SUJOY on 05/09/25.
//

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
    
    private let repository: TaskRepositoryProtocol
    
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
    
    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
        fetchTasks()
    }
    
    func fetchTasks() {
        tasks = repository.fetchTasks()
        sortTasks()
    }
    
    func addTask() {
        guard !newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let task = TaskItem(
            title: newTaskTitle,
            dueDate: newTaskDueDate,
            priority: newTaskPriority
        )
        
        repository.addTask(task)
        fetchTasks()
        resetForm()
        showAddTask = false
    }
    
    func toggleTaskCompletion(_ task: TaskItem) {
        task.isCompleted.toggle()
        repository.updateTask(task)
        fetchTasks()
    }
    
    func deleteTask(_ task: TaskItem) {
        repository.deleteTask(task)
        fetchTasks()
    }
    
    func updateTask(_ task: TaskItem, title: String, dueDate: Date?, priority: TaskItem.Priority) {
        task.title = title
        task.dueDate = dueDate
        task.priority = priority
        repository.updateTask(task)
        fetchTasks()
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
    
    private func resetForm() {
        newTaskTitle = ""
        newTaskDueDate = Date()
        newTaskPriority = .medium
    }
}

