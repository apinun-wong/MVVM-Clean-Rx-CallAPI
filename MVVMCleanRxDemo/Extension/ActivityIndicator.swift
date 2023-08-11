import RxSwift
import RxCocoa

private struct ActivityToken<E> : ObservableConvertibleType, Disposable {
    private let source: Observable<E>
    private let cancelable: Cancelable

    init(source: Observable<E>, disposeAction: @escaping () -> Void) {
        self.source = source
        self.cancelable = Disposables.create(with: disposeAction)
    }

    func dispose() {
        cancelable.dispose()
    }

    func asObservable() -> Observable<E> {
        return source
    }
}

public final class ActivityIndicator : SharedSequenceConvertibleType {
    public typealias Element = Bool
    public typealias SharingStrategy = DriverSharingStrategy
    private let lock = NSRecursiveLock()
    private let variable = BehaviorRelay(value: 0)
    private let loading: SharedSequence<SharingStrategy, Bool>

    public init() {
        loading = variable.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }

    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        return Observable.using({ () -> ActivityToken<O.Element> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }) { token in
            return token.asObservable()
        }
    }

    private func increment() {
        lock.lock()
        variable.accept(variable.value + 1)
        lock.unlock()
    }

    private func decrement() {
        lock.lock()
        variable.accept(variable.value - 1)
        lock.unlock()
    }

    public func asSharedSequence() -> SharedSequence<DriverSharingStrategy, ActivityIndicator.Element> {
        return loading
    }
}

extension ObservableConvertibleType {
    public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}
