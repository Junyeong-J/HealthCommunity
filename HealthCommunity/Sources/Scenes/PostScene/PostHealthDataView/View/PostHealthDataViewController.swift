//
//  PostHealthDataViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import HealthKit

final class PostHealthDataViewController: BaseViewController<PostHealthDataView> {
    
    private let viewModel = PostHealthDataViewModel()
    private let healthStore = HKHealthStore()
    private let selectedDate: Date
    
    let read = Set([
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKSampleType.categoryType(forIdentifier: .appleStandHour)!
    ])
    
    let share = Set([
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!
    ])
    
    init(dateString: String) {
        self.selectedDate = FormatterManager.shared.formatStringToDate(dateString)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorization()
    }
    
    override func bindModel() {
        let input = PostHealthDataViewModel.Input(
            fetchButtonTapped: rootView.fetchButton.rx.tap,
            itemSelected: rootView.collectionView.rx.itemSelected,
            registerButtonTapped: rootView.registerButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.healthData
            .drive(rootView.collectionView.rx.items(
                cellIdentifier: PostHealthDataCollectionViewCell.identifier,
                cellType: PostHealthDataCollectionViewCell.self)) { row, item, cell in
                    cell.configure(data: item)
                }
                .disposed(by: viewModel.disposeBag)
        
        output.fetchButtonTapped
            .drive(with: self, onNext: { owner, _ in
                owner.fetchAllHealthData(for: owner.selectedDate)
            })
            .disposed(by: viewModel.disposeBag)
        
        output.registerButtonTapped
            .drive(with: self, onNext: { owner, data in
                print("전달 데이터: \(data)")
                NotificationCenter.default.post(name: NSNotification.Name("HealthMyRoutine"), object: data)
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    private func requestAuthorization() {
        healthStore.requestAuthorization(toShare: share, read: read) { (success, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else if success {
                print("HealthKit 권한 수락")
            } else {
                print("HealthKit 권한 없어요")
            }
        }
    }
    
    private func fetchAllHealthData(for date: Date) {
        fetchHealthData(for: date, type: .stepCount, unit: HKUnit.count()) { steps in
            let formattedSteps = "\(Int(steps)) 걸음"
            self.viewModel.updateHealthData(type: .steps, value: formattedSteps)
        }
        fetchHealthData(for: date, type: .distanceWalkingRunning, unit: HKUnit.meter()) { distance in
            let distanceInKm = round((distance / 1000) * 10) / 10
            let formattedDistance = "\(distanceInKm) km"
            self.viewModel.updateHealthData(type: .strengthTraining, value: formattedDistance)
        }
        fetchHealthData(for: date, type: .activeEnergyBurned, unit: HKUnit.kilocalorie()) { calories in
            let formattedCalories = "\(Int(calories)) 칼로리"
            self.viewModel.updateHealthData(type: .calories, value: formattedCalories)
        }
        fetchHealthData(for: date, type: .appleStandTime, unit: HKUnit.minute()) { standTimeInMinutes in
            let standTimeInHours = Int(standTimeInMinutes)
            let formattedStandTime = "\(standTimeInHours) 분"
            self.viewModel.updateHealthData(type: .standingHours, value: formattedStandTime)
        }
    }
    
    private func fetchHealthData(for date: Date, type: HKQuantityTypeIdentifier, unit: HKUnit, completion: @escaping (Double) -> Void) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: type) else {
            completion(0)
            return
        }
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                completion(0)
                return
            }
            
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0)
                return
            }
            
            let value = sum.doubleValue(for: unit)
            DispatchQueue.main.async {
                completion(value)
            }
        }
        healthStore.execute(query)
    }

}
