//
//  CalendarViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

class CalendarViewModel: Stepper {
    let steps = PublishRelay<Step>()
    let calendarRepository: CalendarRepository
    private var disposeBag = DisposeBag()
    let dateFormatter = DateFormatter().then {
      $0.dateFormat = "yyyy-MM-dd"
    }
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        let date = PublishRelay<Date>()
        let month = BehaviorRelay<String>(value: "")
    }
    
    struct Output {
        let reloadData = PublishRelay<Void>()
        let date = BehaviorRelay<String>(value: "")
        let calendar = BehaviorRelay<PMSCalendar>(value: PMSCalendar())
        let dateInHome = BehaviorRelay<[String]>(value: .init())
        let dateInSchool = BehaviorRelay<[String]>(value: .init())
        let detailCalendar = BehaviorRelay<[CalendarCell]?>(value: nil)
        let isLoading = BehaviorRelay<Bool>(value: false)
    }
    
    let input = Input()
    let output = Output()
    
    init(calendarRepository: CalendarRepository) {
        self.calendarRepository = calendarRepository
        let activityIndicator = ActivityIndicator()
        
        input.viewDidLoad
            .flatMap {
                calendarRepository.getCalendar()
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(PMSCalendar())
            }.bind(to: output.calendar)
            .disposed(by: disposeBag)
        
        input.date
            .map { self.dateFormatter.string(from: $0 )}
            .bind(to: output.date)
            .disposed(by: disposeBag)
        
        output.date
            .subscribe(onNext: { date in
                for (key, value) in self.output.calendar.value {
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
        
        input.month
            .subscribe(onNext: { month in
                var dateInHome = [String]()
                var dateInSchool = [String]()
                for (key, value) in self.output.calendar.value {
                    if key == String(month) {
                        for (key, value) in value {
                            if value.contains("의무귀가") {
                                dateInHome.append(key)
                            } else if !value.contains("빙학") || !value.contains("토요휴업일") {
                                dateInSchool.append(key)
                            }
                        }
                    }
                }
                self.output.dateInHome.accept(dateInHome)
                self.output.dateInSchool.accept(dateInSchool)
                self.output.reloadData.accept(())
            }).disposed(by: disposeBag)
        
        activityIndicator
            .asObservable()
            .bind(to: output.isLoading)
            .disposed(by: disposeBag)
        
    }
    
    func mapError(error: Int) -> String {
        if error == 1 {
            return LocalizedString.noInternetErrorMsg.localized
        } else if error == 401 {
            Log.info("Token Refresh wasn't complete")
            return "내부 로직 오류"
        } else {
            return LocalizedString.unknownErrorMsg.localized
        }
    }
    
    func mapError(error: Int) -> AccessibilityString {
        if error == 1 {
            return .noInternetErrorMsg
        } else if error == 401 {
            Log.info("Token Refresh wasn't complete")
            return .unknownErrorMsg
        } else {
            return .unknownErrorMsg
        }
    }
}
