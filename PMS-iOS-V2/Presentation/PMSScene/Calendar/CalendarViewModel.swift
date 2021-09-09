//
//  CalendarViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

final public class CalendarViewModel: Stepper {
    public let steps = PublishRelay<Step>()
    public let repository: CalendarRepository
    private var disposeBag = DisposeBag()
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
    }
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        let date = BehaviorRelay<Date>(value: Date())
        let selectedDate = BehaviorRelay<Date>(value: Date())
        let month =  BehaviorRelay<String>(value: String(Date().get(.month)))
        let noInternet = PublishRelay<Void>()
    }
    
    public struct Output {
        let reloadData = PublishRelay<Void>()
        let date = BehaviorRelay<String>(value: "")
        let selectedDate = PublishRelay<String>()
        let calendar = PublishRelay<PMSCalendar>()
        let dateInHome = BehaviorRelay<[String]>(value: .init())
        let dateInSchool = BehaviorRelay<[String]>(value: .init())
        let detailCalendar = BehaviorRelay<[CalendarCell]?>(value: nil)
        let isLoading = BehaviorRelay<Bool>(value: false)
    }
    
    public let input = Input()
    public let output = Output()
    
    public init(repository: CalendarRepository) {
        self.repository = repository
        let activityIndicator = ActivityIndicator()
        
        input.noInternet
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
                }
            })
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .flatMap { [weak self] _ in
                repository.getCalendar()
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        guard let self = self else { return }
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(PMSCalendar())
            }.bind(to: output.calendar)
            .disposed(by: disposeBag)
        
        input.date
            .map { self.dateFormatter.string(from: $0 )}
            .bind(to: output.date)
            .disposed(by: disposeBag)
        
        input.selectedDate
            .map { self.dateFormatter.string(from: $0 )}
            .bind(to: output.selectedDate)
            .disposed(by: disposeBag)
        
        input.month
            .subscribe(onNext: { month in
                if UserDefaults.shared.object(forKey: "dateInHome") != nil {
                    let dateInHome = UserDefaults.shared.object(forKey: "dateInHome") as! [[String]]
                    let dateInSchool = UserDefaults.shared.object(forKey: "dateInSchool") as! [[String]]
                    self.output.dateInHome.accept(dateInHome[Int(month)!])
                    self.output.dateInSchool.accept(dateInSchool[Int(month)!])
                    self.output.reloadData.accept(())
                }
            }).disposed(by: disposeBag)
        
        output.calendar
            .map {
                let ud = UserDefaults.shared.object(forKey: "PMSCalendar")

                if ud == nil {
                    UserDefaults.shared.setValue($0, forKey: "PMSCalendar")
                    self.saveUserDefaults(calendar: $0)
                } else if ud as! PMSCalendar == $0 {
                    return String(Date().get(.month))
                } else if !$0.isEmpty {
                    UserDefaults.shared.setValue($0, forKey: "PMSCalendar")
                    self.saveUserDefaults(calendar: $0)
                }
                return String(Date().get(.month))
            }
            .bind(to: input.month)
            .disposed(by: disposeBag)
        
        output.selectedDate
            .subscribe(onNext: { [weak self] date in
                let ud = UserDefaults.shared.object(forKey: "PMSCalendar")
                
                guard let self = self else { return }
                
                for (key, value) in ud as! PMSCalendar {
                    if key == String(self.input.month.value) {
                        var cells = [CalendarCell]()
                        for (key, value) in value {
                            if self.output.dateInHome.value.contains(date) && date == key {
                                let splitedDate = date.split(separator: "-")
                                let result = String(splitedDate[1] + " / " + splitedDate[2])
                                for val in value {
                                    cells.append(CalendarCell(date: result, event: val, isHome: true))
                                }
                            } else if self.output.dateInSchool.value.contains(date) && date == key {
                                let splitedDate = date.split(separator: "-")
                                let result = String(splitedDate[1] + " / " + splitedDate[2])
                                for val in value {
                                    cells.append(CalendarCell(date: result, event: val, isHome: false))
                                }
                            }
                        }
                        if cells.isEmpty {
                            self.output.detailCalendar.accept([CalendarCell(label: .noEventPlaceholder)])
                        } else {
                            self.output.detailCalendar.accept(cells)
                        }
                    }
                }
            }).disposed(by: disposeBag)
        
        activityIndicator
            .asObservable()
            .bind(to: output.isLoading)
            .disposed(by: disposeBag)
    }
    
    private func mapError(error: Int) -> String {
        if error == 1 {
            return LocalizedString.noInternetErrorMsg.localized
        } else if error == 401 {
            Log.info("Token Refresh wasn't complete")
            return "내부 로직 오류"
        } else {
            return LocalizedString.unknownErrorMsg.localized
        }
    }
    
    private func mapError(error: Int) -> AccessibilityString {
        if error == 1 {
            return .noInternetErrorMsg
        } else if error == 401 {
            Log.info("Token Refresh wasn't complete")
            return .unknownErrorMsg
        } else {
            return .unknownErrorMsg
        }
    }
    
    private func saveUserDefaults(calendar: PMSCalendar) {
        var dateInHome = [[String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]()] // 총 13개
        var dateInSchool =  [[String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]()]
        
        for (key, value) in calendar { // key: month
            for (date, value) in value {
                if value.contains("의무귀가") {
                    dateInHome[Int(key)!].append(date)
                    
                } else if !value.contains("토요휴업일") {
                    dateInSchool[Int(key)!].append(date)
                }
            }
        }
        UserDefaults.shared.setValue(dateInHome, forKey: "dateInHome")
        UserDefaults.shared.setValue(dateInSchool, forKey: "dateInSchool")
    }
}

public extension Date {
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
