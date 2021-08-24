import UIKit
import RxCocoa
import RxSwift

private enum Constants {
    static let validColor: UIColor = .blue
    static let invalidColor: UIColor = .red
    static let buttonUnavailableColor: UIColor = .blue.withAlphaComponent(0.1)
    static let buttonAvailableColor: UIColor = .blue.withAlphaComponent(1.0)
}

final class AuthViewController: UIViewController {

    @IBOutlet private var containerStackView: UIStackView!
    @IBOutlet private var loginContainerView: UIView!
    @IBOutlet private var passwordContainerView: UIView!
    @IBOutlet private var loginIndicatorView: UIView!
    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var passwordIndicatorView: UIView!
    @IBOutlet private var authanticateButton: UIButton!

    private let viewModel = AuthViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupBindings()
    }

    private func setup() {
        loginIndicatorView.backgroundColor = Constants.validColor
        passwordIndicatorView.backgroundColor = Constants.validColor
    }

    private func setupBindings() {
        viewModel.isLoginValid.bind { [weak self] isValid in
            guard let self = self else { return }

            self.loginIndicatorView.backgroundColor = isValid ? Constants.validColor : Constants.invalidColor
        }.disposed(by: disposeBag)

        viewModel.isPasswordValid.bind { [weak self] isValid in
            guard let self = self else { return }

            self.passwordIndicatorView.backgroundColor = isValid ? Constants.validColor : Constants.invalidColor
        }.disposed(by: disposeBag)

        viewModel.isValid.bind { [weak self] isValid in
            guard let self = self else { return }

            UIView.animate(withDuration: CATransaction.animationDuration()) {
                self.authanticateButton.backgroundColor = isValid ? Constants.buttonAvailableColor : Constants.buttonUnavailableColor
            }
        }.disposed(by: disposeBag)

        loginTextField.rx.text.orEmpty.bind(to: viewModel.login).disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        viewModel.isValid.bind(to: authanticateButton.rx.isEnabled).disposed(by: disposeBag)

        authanticateButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }

                self.handleAuthantification()
            }
            .disposed(by: disposeBag)
    }

    private func handleAuthantification() {
        view.endEditing(true)
        viewModel.tryLogin()
        self.showAlertMessage(with: "Sign in is successful")
    }

    private func showAlertMessage(with message: String) {
        let alert = UIAlertController(title: "Success",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "OK",
                              style: .default,
                              handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
