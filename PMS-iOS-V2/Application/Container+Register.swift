//
//  Container+Register.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Swinject
import SwinjectAutoregistration
import Moya

extension Container {
    func registerDependencies() {
        registerTabbar()
        registerMypage()
        registerPMS()
        registerIntroduce()
    }
    
    func registerTabbar() {
        registerTabbarRepositories()
        registerTabbarViewModels()
        registerTabbarViewControllers()
    }
    
    func registerMypage() {
        registerMypageRepositories()
        registerMypageViewModels()
        registerMypageViewControllers()
    }
    
    func registerPMS() {
        registerPMSRepositories()
        registerPMSViewModels()
        registerPMSViewControllers()
    }
    
    func registerIntroduce() {
        registerIntroduceViewModels()
        registerIntroduceViewControllers()
    }
    
    // MARK: - Tab bar
    
    func registerTabbarRepositories() {
        autoregister(CalendarRepository.self, initializer: DefaultCalendarRepository.init)
        autoregister(MealRepository.self, initializer: DefaultMealRepository.init)
        autoregister(NoticeRepository.self, initializer: DefaultNoticeRepository.init)
        autoregister(IntroduceRepository.self, initializer: DefaultIntroduceRepository.init)
        autoregister(MypageRepository.self, initializer: DefaultMypageRepository.init)
    }
    
    func registerTabbarViewModels() {
        autoregister(CalendarViewModel.self, initializer: CalendarViewModel.init)
        autoregister(MealViewModel.self, initializer: MealViewModel.init)
        autoregister(NoticeViewModel.self, initializer: NoticeViewModel.init)
        autoregister(IntroduceViewModel.self, initializer: IntroduceViewModel.init)
        autoregister(MypageViewModel.self, initializer: MypageViewModel.init)
    }
    
    func registerTabbarViewControllers() {
        autoregister(CalendarViewController.self, initializer: CalendarViewController.init)
        autoregister(MealViewController.self, initializer: MealViewController.init)
        autoregister(NoticeViewController.self, initializer: NoticeViewController.init)
        autoregister(IntroduceViewController.self, initializer: IntroduceViewController.init)
        autoregister(MypageViewController.self, initializer: MypageViewController.init)
    }
    
    // MARK: - Mypage
    
    func registerMypageRepositories() {
        autoregister(ChangePasswordRepository.self, initializer: DefaultChangePasswordRepository.init)
        autoregister(OutingListRepository.self, initializer: DefaultOutingListRepository.init)
        autoregister(PointListRepository.self, initializer: DefaultPointListRepository.init)
    }
    
    func registerMypageViewModels() {
        autoregister(ChangePasswordViewModel.self, initializer: ChangePasswordViewModel.init)
        autoregister(OutingListViewModel.self, initializer: OutingListViewModel.init)
        autoregister(PointListViewModel.self, initializer: PointListViewModel.init)
    }
    
    func registerMypageViewControllers() {
        autoregister(ChangePasswordViewController.self, initializer: ChangePasswordViewController.init)
        autoregister(OutingListViewController.self, initializer: OutingListViewController.init)
        autoregister(PointListViewController.self, initializer: PointListViewController.init)
    }
    
    // MARK: - PMS
    
    func registerPMSRepositories() {
        autoregister(LoginRepository.self, initializer: DefaultLoginRepository.init)
        autoregister(RegisterRepository.self, initializer: DefaultRegisterRepository.init)
    }
    
    func registerPMSViewModels() {
        autoregister(PMSViewModel.self, initializer: PMSViewModel.init)
        autoregister(LoginViewModel.self, initializer: LoginViewModel.init)
        autoregister(RegisterViewModel.self, initializer: RegisterViewModel.init)
    }
    
    func registerPMSViewControllers() {
        autoregister(PMSViewController.self, initializer: PMSViewController.init)
        autoregister(LoginViewController.self, initializer: LoginViewController.init)
        autoregister(RegisterViewController.self, initializer: RegisterViewController.init)
    }
    
    // MARK: - Introduce
    
    func registerIntroduceViewModels() {
        autoregister(ClubViewModel.self, initializer: ClubViewModel.init)
        autoregister(CompanyViewModel.self, initializer: CompanyViewModel.init)
        autoregister(DeveloperViewModel.self, initializer: DeveloperViewModel.init)
    }
    
    func registerIntroduceViewControllers() {
        autoregister(ClubViewController.self, initializer: ClubViewController.init)
        autoregister(CompanyViewController.self, initializer: CompanyViewController.init)
        autoregister(DeveloperViewController.self, initializer: DeveloperViewController.init)
    }
}
