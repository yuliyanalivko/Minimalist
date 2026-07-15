enum ContentState<T: Equatable>: Equatable {
    case loading
    case content(T)
    case emptySearch
    case empty
}
