//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/10.
//

import Foundation
import ModernRIBs
import Combine

protocol EnterAmountRouting: ViewableRouting {
	// TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
	var listener: EnterAmountPresentableListener? { get set }
	// TODO: Declare methods the interactor can invoke the presenter to present data.
	func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)

	func startLoading()
	func stopLoading()
}

protocol EnterAmountListener: AnyObject {
	// TODO: Declare methods the interactor can invoke to communicate with other RIBs.

	func enterAmountDidTapClose()
	func enterAmountDidTapPaymentMethod()
	func enterAmountDidFinishTopup()
}

protocol EnterAmountInteractorDependency {
	var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
	var superPayRepository: SuperPayRepository { get }
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {

	weak var router: EnterAmountRouting?
	weak var listener: EnterAmountListener?

	private let dependecy: EnterAmountInteractorDependency

	private var cancellables: Set<AnyCancellable>

	// TODO: Add additional dependencies to constructor. Do not perform any logic
	// in constructor.
	init(
		presenter: EnterAmountPresentable,
		dependency: EnterAmountInteractorDependency
	) {
		self.dependecy = dependency
		self.cancellables = .init()
		super.init(presenter: presenter)
		presenter.listener = self
	}

	override func didBecomeActive() {
		super.didBecomeActive()
		// TODO: Implement business logic here.

		dependecy.selectedPaymentMethod.sink { [weak self] paymentMethod in
			self?.presenter.updateSelectedPaymentMethod(with: SelectedPaymentMethodViewModel(paymentMethod))
		}.store(in: &cancellables)
	}

	override func willResignActive() {
		super.willResignActive()
		// TODO: Pause any business logic.
	}

	// EnterAmountPresentableListener
	func didTapClose() {
		listener?.enterAmountDidTapClose()
	}

	func didTapPaymentMethod() {
		listener?.enterAmountDidTapPaymentMethod()
	}

	func didTapTopup(with amount: Double) {
		presenter.startLoading()

		dependecy.superPayRepository.topup(
			amount: amount,
			paymentMethod: dependecy.selectedPaymentMethod.value.id
		)
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { [weak self] _ in
					self?.presenter.stopLoading()
				},
				receiveValue: { [weak self] in
					self?.listener?.enterAmountDidFinishTopup()
				}
			).store(in: &cancellables)
	}
}
