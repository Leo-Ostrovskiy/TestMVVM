import Foundation
import RxCocoa
import RxSwift

struct User {
    var login: String
    var password: String
}

final class AuthViewModel {
    let login = BehaviorSubject<String>(value: "")
    let isLoginValid = BehaviorSubject<Bool>(value: true)

    let password = BehaviorSubject<String>(value: "")
    let isPasswordValid = BehaviorSubject<Bool>(value: true)

    let isValid = BehaviorSubject<Bool>(value: false)
    private let disposeBag = DisposeBag()

    init() { setupBinding() }

    private func setupBinding() {
        login.map { $0.isLoginValid() }.bind(to: isLoginValid).disposed(by: disposeBag)
        password.map { $0.isPasswordValid() }.bind(to: isPasswordValid).disposed(by: disposeBag)
        Observable.combineLatest(isLoginValid, isPasswordValid)
            .map { $0 && $1 }
            .bind(to: isValid)
            .disposed(by: disposeBag)
    }
}

// MARK: - Login
extension AuthViewModel {
    func tryLogin()  {
        // work with BE
        print("work with BE")
    }
}
