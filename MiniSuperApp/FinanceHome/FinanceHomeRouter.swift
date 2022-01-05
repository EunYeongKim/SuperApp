import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
	func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
  
	private let superPayDashboardBuildable: SuperPayDashboardBuildable
	private var superPayRouting: Routing?

	private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
	private var cardOnFileRouting: Routing?

	private let addPaymentMethodBuildable: AddPaymentMethodBuildable
	private var addPaymentRouting: Routing?

  init(
	interactor: FinanceHomeInteractable,
	viewController: FinanceHomeViewControllable,
	superPayDashboardBuildable: SuperPayDashboardBuildable,
	cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
	addPaymentMethodBuildable: AddPaymentMethodBuildable
  ) {
	  self.addPaymentMethodBuildable = addPaymentMethodBuildable
	  self.superPayDashboardBuildable = superPayDashboardBuildable
	  self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }

	func attachSuperPayDashboard() {
		if superPayRouting != nil {
			return
		}

		let router = superPayDashboardBuildable.build(withListener: interactor)

		let dashboard = router.viewControllable
		viewController.addDashboard(dashboard)

		self.superPayRouting = router
		attachChild(router)
	}

	func attachCardOnFileDashboard() {
		if cardOnFileRouting != nil {
			return
		}

		let router = cardOnFileDashboardBuildable.build(withListener: interactor)

		let dashboard = router.viewControllable
		viewController.addDashboard(dashboard)

		self.cardOnFileRouting = router
		attachChild(router)
	}

	func attachAddPaymentMethod() {
		if addPaymentRouting != nil {
			return
		}

		let router = addPaymentMethodBuildable.build(withListener: interactor)

		/// navigation bar가 필요하기 때문에 navigation bar에 한번 싸서 present
		let navigation = NavigationControllerable(root: router.viewControllable)
		viewControllable.present(navigation, animated: true, completion: nil)

		addPaymentRouting = router
		attachChild(router)
	}

	func detachAddPaymentMethod() {
		guard let router = addPaymentRouting else {
			return
		}

		viewControllable.dismiss(completion: nil)

		detachChild(router)
		addPaymentRouting = nil
	}
}
