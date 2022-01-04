import ModernRIBs

protocol FinanceHomeDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency {
/// 자식 리블렛에서는 값을 읽을수만 있는 readonly publisher를 넘겨줘야함
	var balance: ReadOnlyCurrentValuePublisher<Double> { balancePublisher }
/// 잔액을 update하고 싶을때 쓰는 publisher
	private let balancePublisher: CurrentValuePublisher<Double>

  init(
	dependency: FinanceHomeDependency,
	balance: CurrentValuePublisher<Double>
  ) {
	  self.balancePublisher = balance
	  super.init(dependency: dependency)
  }
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
  
  override init(dependency: FinanceHomeDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
	let balancePublisher = CurrentValuePublisher<Double>(10000)

    let component = FinanceHomeComponent(
		dependency: dependency,
		balance: balancePublisher
	)
    let viewController = FinanceHomeViewController()
    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener

	  let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)

    return FinanceHomeRouter(
		interactor: interactor,
		viewController: viewController,
		superPayDashboardBuildable: superPayDashboardBuilder
	)
  }
}
