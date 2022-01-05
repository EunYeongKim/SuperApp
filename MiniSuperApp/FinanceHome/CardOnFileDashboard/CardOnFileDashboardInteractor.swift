//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/04.
//

import ModernRIBs
import Combine

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
    var listener: CardOnFileDashboardPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.

	func update(with viewmodels: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
	func cardOnFileDashboardDidTapAddPaymentMethod()
}

protocol CardOnFileDashboardInteractorDependency {
	var cardsOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {

    weak var router: CardOnFileDashboardRouting?
    weak var listener: CardOnFileDashboardListener? //부모리블렛의 리스너임

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
	private let dependency: CardOnFileDashboardInteractorDependency

	private var cancellable: Set<AnyCancellable>

    init(
		presenter: CardOnFileDashboardPresentable,
		dependency: CardOnFileDashboardInteractorDependency
	) {
		self.dependency = dependency
		self.cancellable = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.

		dependency.cardsOnFileRepository.cardOnFile.sink { [weak self] methods in
			let viewModels = methods.prefix(5).map(PaymentMethodViewModel.init)
			self?.presenter.update(with: viewModels)
		}.store(in: &cancellable)
    }

	/// Interactor가 detach되기 직전에 불리기 때문에 self에 캡쳐되어있던 것이 사라져서 retain cycle이 사라짐
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.

		cancellable.forEach { $0.cancel() }
		cancellable.removeAll()
    }

	// 화면의 일부만 담당하는 cardOnFileDashboard보다는 FinanceHome이 명확해보임
	func didTapAddPaymentMethod() {
		listener?.cardOnFileDashboardDidTapAddPaymentMethod()
	}
}
