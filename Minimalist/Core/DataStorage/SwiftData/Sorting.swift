import Foundation
import SwiftData

protocol SortableByName {
    var name: String { get set }
}

extension SortableByName where Self: PersistentModel {
    static func nameSortDescriptor() -> SortDescriptor<Self> {
        SortDescriptor(\.name, order: .forward)
    }
}

protocol Sortable {
    associatedtype SortableModel: PersistentModel
    static func sortDescriptors(for sort: StorageSortOption) -> [SortDescriptor<SortableModel>]
}

extension SwiftDataCategory: Sortable {
    static func sortDescriptors(for sort: StorageSortOption) -> [SortDescriptor<SwiftDataCategory>] {
        switch sort {
        case .name:
            [nameSortDescriptor()]
        }
    }
}

extension SwiftDataItem: Sortable {
    static func sortDescriptors(for sort: StorageSortOption) -> [SortDescriptor<SwiftDataItem>] {
        switch sort {
        case .name:
            [nameSortDescriptor()]
        }
    }
}
