import Foundation

enum ViewState<T> {
    case waiting
    case loading
    case loaded(items: [T])
}
