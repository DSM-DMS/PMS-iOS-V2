//
//  MypageDelegate.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/06/02.
//

import Foundation

protocol ChangeNicknameDelegate {
    func dismissChangeNickname()
    func success()
}

protocol StudentListDelegate {
    func changeStudent(student: UsersStudent)
    func addStudentTapped()
    func delete(student: UsersStudent)
}

protocol AddStudentDelegate {
    func dismissAddStudent()
}
