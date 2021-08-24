import Quick
import Nimble
import RxSwift
import RxTest
@testable import testMVVM

class AuthViewModelTest: QuickSpec {
    private let disposeBag = DisposeBag()

    override func spec() {
        describe("AuthViewModel") {
            context("Handle") {
                context("Login Validation") {
                    context("Write incorrect login") {
                        it("Should return not Valid") {
                            let login = "qwerty"
                            expect(login.isLoginValid()).to(equal(false))
                        }
                    }

                    context("Write correct login") {
                        it("Should return Valid") {
                            let login = "qwerty@gmail.com"
                            expect(login.isLoginValid()).to(equal(true))
                        }
                    }
                }

                context("Password Validation") {
                    context("Write incorrect password") {
                        it("Should return not Valid") {
                            let login = "123"
                            expect(login.isPasswordValid()).to(equal(false))
                        }
                    }

                    context("Write correct password") {
                        it("Should return Valid") {
                            let login = "123qwerty"
                            expect(login.isPasswordValid()).to(equal(true))
                        }
                    }
                }

                context("Check validation while writing") {
                    context("Valid writting login and password") {
                        it("Should get viewModel.isValid == true") {
                            let scheduler = TestScheduler(initialClock: 0)
                            let testObserver = scheduler.createObserver(Bool.self)
                            let viewModel = AuthViewModel()

                            viewModel.isValid.asDriver(onErrorJustReturn: false)
                                .drive(testObserver)
                                .disposed(by: self.disposeBag)

                            // Given
                            scheduler.createColdObservable([
                                .next(1, ""),
                                .next(2, "qwe"),
                                .next(3, "qwerty"),
                                .next(4, "qwerty@asdf"),
                                .next(5, "qwerty@asdf.com")
                            ])
                            .bind(to: viewModel.login)
                            .disposed(by: self.disposeBag)

                            scheduler.createColdObservable([
                                .next(6, ""),
                                .next(7, "qwe"),
                                .next(8, "qwer"),
                                .next(9, "qwerty"),
                                .next(10, "qwertyui")
                            ]).bind(to: viewModel.password)
                            .disposed(by: self.disposeBag)

                            scheduler.start()

                            // Result
                            expect(testObserver.events).to(equal([
                                .next(0, false),
                                .next(1, false),
                                .next(2, false),
                                .next(3, false),
                                .next(4, false),
                                .next(5, false),
                                .next(6, false),
                                .next(7, false),
                                .next(8, false),
                                .next(9, true),
                                .next(10, true)
                            ]))
                        }
                    }

                    context("Valid writting login and password, after delete part of password") {
                        it("Should get viewModel.isValid == false") {
                            let scheduler = TestScheduler(initialClock: 0)
                            let testObserver = scheduler.createObserver(Bool.self)
                            let viewModel = AuthViewModel()

                            viewModel.isValid.asDriver(onErrorJustReturn: false)
                                .drive(testObserver)
                                .disposed(by: self.disposeBag)

                            // Given
                            scheduler.createColdObservable([
                                .next(1, ""),
                                .next(2, "qwe"),
                                .next(3, "qwerty"),
                                .next(4, "qwerty@asdf"),
                                .next(5, "qwerty@asdf.com")
                            ])
                            .bind(to: viewModel.login)
                            .disposed(by: self.disposeBag)

                            scheduler.createColdObservable([
                                .next(6, ""),
                                .next(7, "qwe"),
                                .next(8, "qwer"),
                                .next(9, "qwerty"),
                                .next(10, "qwer")
                            ]).bind(to: viewModel.password)
                            .disposed(by: self.disposeBag)

                            scheduler.start()

                            // Result
                            expect(testObserver.events).to(equal([
                                .next(0, false),
                                .next(1, false),
                                .next(2, false),
                                .next(3, false),
                                .next(4, false),
                                .next(5, false),
                                .next(6, false),
                                .next(7, false),
                                .next(8, false),
                                .next(9, true),
                                .next(10, false)
                            ]))
                        }
                    }
                }
            }
        }
    }
}
