//
//  CalendarViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

final class CalendarViewModel: Stepper {
    let steps = PublishRelay<Step>()
    let repository: CalendarRepository
    private var disposeBag = DisposeBag()
    let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
    }
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        let date = BehaviorRelay<Date>(value: Date())
        let selectedDate = BehaviorRelay<Date>(value: Date())
        let month = BehaviorRelay<String>(value: "")
        let noInternet = PublishRelay<Void>()
    }
    
    struct Output {
        let reloadData = PublishRelay<Void>()
        let date = BehaviorRelay<String>(value: "")
        let selectedDate = BehaviorRelay<String>(value: "")
        let calendar = BehaviorRelay<PMSCalendar>(value: PMSCalendar())
        let dateInHome = BehaviorRelay<[String]>(value: .init())
        let dateInSchool = BehaviorRelay<[String]>(value: .init())
        let detailCalendar = BehaviorRelay<[CalendarCell]?>(value: nil)
        let isLoading = BehaviorRelay<Bool>(value: false)
    }
    
    let input = Input()
    let output = Output()
    
    init(repository: CalendarRepository) {
        self.repository = repository
        let activityIndicator = ActivityIndicator()
        
        input.noInternet
            .subscribe(onNext: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
                }
            })
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .flatMap {
                repository.getCalendar()
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
        
        input.selectedDate
            .map { self.dateFormatter.string(from: $0 )}
            .bind(to: output.selectedDate)
            .disposed(by: disposeBag)
        
        input.month
            .subscribe(onNext: { month in
                var dateInHome = [String]()
                var dateInSchool = [String]()
                for (key, value) in self.output.calendar.value {
                    if key == String(month) {
                        for (key, value) in value {
                            if value.contains("의무귀가") {
                                dateInHome.append(key)
                            } else if !value.contains("빙학") && !value.contains("토요휴업일") {
                                dateInSchool.append(key)
                            }
                        }
                    }
                }
                self.output.dateInHome.accept(dateInHome.sorted())
                self.output.dateInSchool.accept(dateInSchool.sorted())
                self.output.reloadData.accept(())
            }).disposed(by: disposeBag)
        
        output.calendar
            .map { _ in
                return String(Date().get(.month))
            }
            .bind(to: input.month)
            .disposed(by: disposeBag)
        
        output.selectedDate
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
}
