//
//  MypageDelegate.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/06/02.
//

import Foundation

public protocol ChangeNicknameDelegate: AnyObject {
    func dismissChangeNickname()
    func success()
}

public protocol StudentListDelegate: AnyObject {
    func changeStudent(student: UsersStudent)
    func addStudentTapped()
    func delete(student: UsersStudent)
}

public protocol AddStudentDelegate: AnyObject {
    func dismissAddStudent()
}
