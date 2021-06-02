//
//  MypageRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import RxSwift

protocol MypageRepository {
    func getUser() -> Single<User>
    func getStudent(number: Int) -> Single<Student>
    func changeNickname(name: String) -> Single<Bool>
    func addStudent(number: Int) -> Single<Bool>
    func deleteStudent(number: Int) -> Single<Bool>
    func getNewStudent() -> Single<User>
}
