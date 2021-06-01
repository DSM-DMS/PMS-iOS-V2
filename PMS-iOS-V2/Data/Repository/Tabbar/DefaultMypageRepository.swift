//
//  MypageRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import Moya
import RxSwift

final class DefaultMypageRepository: MypageRepository {
    let provider: MoyaProvider<AuthApi>
    
    init(provider: MoyaProvider<AuthApi>?) {
        self.provider = provider ?? MoyaProvider<AuthApi>()
    }
    
    func getUser() -> Single<User> {
        provider.rx.request(.userInform)
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(User.self)
            .map {
                if UDManager.shared.student == nil && !$0.students.isEmpty {
                    UDManager.shared.student = String($0.students.first!.number) + " " + $0.students.first!.name
                }
                return $0
            }
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    func getStudent(number: Int) -> Single<Student> {
        provider.rx.request(.mypage(number: number))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(Student.self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    func changeNickname(name: String) -> Single<Bool> {
        provider.rx.request(.changeNickname(name: name))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map { _ in true }
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    func addStudent(number: Int) -> Single<Bool> {
        provider.rx.request(.addStudent(number: number))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map { _ in true }
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    func deleteStudent(number: Int) -> Single<Bool> {
        provider.rx.request(.deleteStudent(number: number))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map { _ in true }
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
}
