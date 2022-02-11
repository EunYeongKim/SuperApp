//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/04.
//

import Foundation
import Combine
import CombineUtil
import FinanceEntity
import Network

public protocol CardOnFileRepository {
	var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }

	func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error>
    func fetch()
}

public final class CardOnFileRepositoryImp: CardOnFileRepository {

	public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodSubject }

	private let paymentMethodSubject = CurrentValuePublisher<[PaymentMethod]>([])

	public func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> {
		let request = AddCardRequest(baseURL: baseURL, info: info)
        
        return network.send(request)
            .map(\.output.card)
            .handleEvents(
                receiveSubscription: nil,
                receiveOutput: { [weak self] method in
                    guard let self = self else {
                        return
                    }
                    self.paymentMethodSubject.send(self.paymentMethodSubject.value + [method])
                },
                receiveCompletion: nil,
                receiveCancel: nil,
                receiveRequest: nil)
            .eraseToAnyPublisher()
	}
    
    public func fetch() {
        let request = CardOnFileRequest(baseURL: baseURL)
        return network.send(request).map(\.output.cards)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] cards in
                    self?.paymentMethodSubject.send(cards)
                }
            ).store(in: &cancellable)
    }
    
    private let network: Network
    private let baseURL: URL
    private var cancellable: Set<AnyCancellable>
    
    public init(network: Network, baseURL: URL) {
        self.network = network
        self.baseURL = baseURL
        self.cancellable = .init()
    }
}
