//
//  Combine+Utils.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/04.
//

import Foundation
import CombineExt
import Combine


/// currentValue Subject의 변형으로 subscriber들이 가장 최신값을 접근할 수 있게 해주되, 직접 값을 send는 할 수 없도록 함
/// combine만으로는 불가능해서 만든 객체
///
public class ReadOnlyCurrentValuePublisher<Element>: Publisher {

	public typealias Output = Element
	public typealias Failure = Never

	public var value: Element {
		currentValueRelay.value
	}

	fileprivate let currentValueRelay: CurrentValueRelay<Output>

	fileprivate init(_ initialValue: Element) {
		currentValueRelay = CurrentValueRelay(initialValue)
	}

	public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Element == S.Input {
		currentValueRelay.receive(subscriber: subscriber)
	}
}

/// 잔액을 관리하는 객체가 currentValuePublisher를 생성해서 잔액이 바뀔때마다 `send`를 해줌
/// 잔액을 사용하는 객체들은 ReadOnlyCurrentValuePublisher 타입으로 받아서 값을 send를 직접할 수는 없되, value 프로퍼티를 통해서
/// 현재 잔액 값을 받아갈 수 있도록 만들어줌

public final class CurrentValuePublisher<Element>: ReadOnlyCurrentValuePublisher<Element> {

	typealias Output = Element
	typealias Failure = Never

	public override init(_ initialValue: Element) {
		super.init(initialValue)
	}

	public func send(_ value: Element) {
		currentValueRelay.accept(value)
	}
}

