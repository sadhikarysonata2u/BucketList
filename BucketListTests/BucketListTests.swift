//
//  BucketListTests.swift
//  BucketListTests
//
//  Created by SUJOY on 05/09/25.
//

import Testing
@testable import BucketList

final class MockTaskRepository: TaskRepositoryProtocol {
    var tasks: [TaskItem] = []
    
    func fetchTasks() -> [TaskItem] {
        tasks
    }
    
    func addTask(_ task: TaskItem) {
        tasks.append(task)
    }
    
    func updateTask(_ task: TaskItem) {
        // find & replace
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func deleteTask(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
    }
}


struct TaskViewModelTests {
    
    @Test @MainActor
    func addTask() async throws {
        let repo = MockTaskRepository()
        let viewModel = TaskViewModel(repository: repo)
        
        viewModel.newTaskTitle = "Buy Milk"
        viewModel.newTaskPriority = .high
        viewModel.addTask()
        
        #expect(viewModel.tasks.count == 1)
        #expect(viewModel.tasks.first?.title == "Buy Milk")
        #expect(viewModel.tasks.first?.priority == .high)
    }
    
    @Test @MainActor
    func deleteTask() async throws {
        let task = TaskItem(title: "Temp Task", dueDate: nil, priority: .low)
        let repo = MockTaskRepository()
        repo.tasks = [task]
        let viewModel = TaskViewModel(repository: repo)
        viewModel.fetchTasks()
        
        viewModel.deleteTask(task)
        
        #expect(viewModel.tasks.isEmpty)
    }
    
    @Test @MainActor
    func toggleCompletion() async throws {
        let task = TaskItem(title: "Walk Dog", dueDate: nil, priority: .medium)
        let repo = MockTaskRepository()
        repo.tasks = [task]
        let viewModel = TaskViewModel(repository: repo)
        viewModel.fetchTasks()
        
        viewModel.toggleTaskCompletion(task)
        
        #expect(viewModel.tasks.first?.isCompleted == true)
    }
    
    @Test @MainActor
    func sortByTitle() async throws {
        let repo = MockTaskRepository()
        repo.tasks = [
            TaskItem(title: "Zebra", dueDate: nil, priority: .medium),
            TaskItem(title: "Apple", dueDate: nil, priority: .high)
        ]
        let viewModel = TaskViewModel(repository: repo)
        viewModel.fetchTasks()
        
        viewModel.sortOption = .title
        viewModel.sortTasks()
        
        #expect(viewModel.tasks.map { $0.title } == ["Apple", "Zebra"])
    }
    
    @Test @MainActor
    func filterCompleted() async throws {
        let t1 = TaskItem(title: "Done", isCompleted: true, dueDate: nil, priority: .low)
        let t2 = TaskItem(title: "Pending", isCompleted: false, dueDate: nil, priority: .low)
        
        let repo = MockTaskRepository()
        repo.tasks = [t1, t2]
        let viewModel = TaskViewModel(repository: repo)
        viewModel.fetchTasks()
        
        viewModel.filterOption = .completed
        let filtered = viewModel.filterTasks()
        
        #expect(filtered.count == 1)
        #expect(filtered.first?.title == "Done")
    }
}

