import UIKit
import RxSwift
import RxCocoa

// MARK: - ViewController Event
public extension Reactive where Base: UIViewController {
    var touchesBegan: ControlEvent<Void> {
        return controlEvent(selector: #selector(Base.touchesBegan(_:with:)))
    }

    var touchesEnded: ControlEvent<Void> {
        return controlEvent(selector: #selector(Base.touchesEnded(_:with:)))
    }

    var viewDidLoad: ControlEvent<Void> {
        return controlEvent(selector: #selector(Base.viewDidLoad))
    }

    var viewWillAppear: ControlEvent<Void> {
        return controlEvent(selector: #selector(Base.viewWillAppear(_:)))
    }

    var viewDidAppear: ControlEvent<Void> {
        return controlEvent(selector: #selector(Base.viewDidAppear(_:)))
    }

    var viewWillDisappear: ControlEvent<Void> {
        return controlEvent(selector: #selector(Base.viewWillDisappear(_:)))
    }

    var viewDidDisappear: ControlEvent<Void> {
        return controlEvent(selector: #selector(Base.viewDidDisappear(_:)))
    }

    func controlEvent(selector: Selector) -> ControlEvent<Void> {
        let source = methodInvoked(selector).map { (_) in () }
        return ControlEvent(events: source)
    }
}

// MARK: - ViewController Element and Error
public extension ObservableType where Element: EventConvertible {

    func elements() -> Observable<Element.Element> {
        return compactMap { $0.event.element }
    }

    func errors() -> Observable<Swift.Error> {
        return compactMap { $0.event.error }
    }
}

// MARK: - Rx Extend Text Color
extension Reactive where Base: UIButton {
    public func textColor(_ state: UIControl.State) -> Binder<UIColor?> {
        return Binder(self.base) { button, color in
            button.setTitleColor(color, for: state)
        }
    }
}

public protocol BoolType {
    var value: Bool { get }
}

extension Bool: BoolType {
    public var value: Bool {
        self
    }
}

public protocol OptionalType {
    associatedtype Wrapped

    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { return self }
}

public extension Observable where Element: OptionalType {
    func ignoreNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
        }
    }
}

public extension Observable where Element: BoolType {
    func filterTrue() -> Observable<Element> {
        return filter({$0.value})
    }

    func filterFalse() -> Observable<Element> {
        return filter({!$0.value})
    }

    func trueCase() -> Observable<Void> {
        return filter({$0.value}).mapVoid()
    }

    func falseCase() -> Observable<Void> {
        return filter({!$0.value}).mapVoid()
    }
}

public extension ObservableType {
    func then<T>(_ task: @escaping (Element) -> Observable<T>) -> Observable<Event<T>> {
        return flatMapLatest { value in
            task(value).materialize()
        }.share()
    }

    func then<T>(_ task: @escaping (Element) -> Observable<T>, cancelWhen: Observable<Void>) -> Observable<Event<T>> {

        let cancel: Observable<(Element?, Bool)> = cancelWhen.mapTo((nil, false))
        let normal: Observable<(Element?, Bool)> = map({($0, true)})

        return Observable.merge([cancel, normal])
            .flatMapLatest { (value, active) -> Observable<Event<T>> in
                guard active, let value else {
                    return .empty()
                }
                return task(value).materialize()
            }
            .share()
    }

    func filterCase(_ predicate: @escaping (Element) -> Bool) -> Observable<Void> {
        return filter(predicate).mapVoid()
    }

    func mapValue<T>(_ value: T) -> Observable<T> {
        return map { (_) -> T in
            return value
        }
    }

    func mapVoid() -> Observable<Void> {
        return map { (_) -> Void in
            return ()
        }
    }

    func wait(_ trigger: PublishRelay<Void>, until duration: RxTimeInterval, scheduler: SchedulerType) -> Observable<Element> {
        return flatMapLatest { [weak trigger] value -> Observable<Element> in
            guard let trigger else {
                return .empty()
            }
            return Observable.amb([
                Observable.just(()).delay(duration, scheduler: scheduler),
                trigger.asObservable()
            ]).take(1).mapTo(value)
        }
    }

    func wait(_ trigger: Observable<Void>) -> Observable<Element> {
        return flatMapLatest { [weak trigger] value -> Observable<Element> in
            guard let trigger else {
                return .empty()
            }
            return trigger.take(1).mapTo(value)

        }
    }

    func allDelay(_ dueTime: RxTimeInterval, scheduler: SchedulerType) -> Observable<Element> {
        return materialize().delay(dueTime, scheduler: scheduler).dematerialize()
    }
}

public extension ControlProperty {

    func twoWayBind (to relay: BehaviorRelay<Element>) -> Disposable {

        let bindToUIDisposable = relay.bind(to: self)

        let bindToRelay = self.subscribe(onNext: { next in
            relay.accept(next)
        }, onCompleted: {
            bindToUIDisposable.dispose()
        })

        return Disposables.create(bindToUIDisposable, bindToRelay)
    }
}

extension ObservableType {
    public func mapTo<R>(_ value: R) -> Observable<R> {
        return map { _ in value }
    }

    public func mapType<T>(_ type: T.Type) -> Observable<T> {
        return map { $0 as? T }
            .filter { $0 != nil }
            .map { $0! }
    }
}

extension Observable {
    static func create(_ closure: @escaping () async throws -> Element) -> Observable<Element> {
        Observable.create { observer in
            let task = Task {
                do {
                    observer.on(.next(try await closure()))
                    observer.on(.completed)
                } catch {
                    observer.on(.error(error))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }
}
