//
//  PaymentViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 9/2/24.
//

import UIKit
import SnapKit
import RxSwift
import iamport_ios
import WebKit

final class PaymentViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let postID: String
    private let paymentAmount: String
    private let paymentTitle: String
    
    init(postID: String, paymentAmount: String, paymentTitle: String) {
        self.postID = postID
        self.paymentAmount = paymentAmount
        self.paymentTitle = paymentTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let wkWebView: WKWebView = {
        let view = WKWebView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureWebView()
        startPayment()
    }
    
    private func configureWebView() {
        view.addSubview(wkWebView)
        wkWebView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func startPayment() {
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: PortOne.pgId),
            merchant_uid: "ios_\(APIKey.key)_\(Int(Date().timeIntervalSince1970))",
            amount: paymentAmount
        ).then {
            $0.pay_method = PayMethod.card.rawValue
            $0.name = paymentTitle
            $0.buyer_name = "전준영"
            $0.app_scheme = "junCompany"
        }
        
        let userCode = PortOne.userCode
        
        Iamport.shared.paymentWebView(
            webViewMode: wkWebView,
            userCode: userCode,
            payment: payment) { [weak self] iamportResponse in
                
                guard let self = self else { return }
                
                print(String(describing: iamportResponse))
                
                LSLPAPIManager.shared.request(api: .payment(.payment(impID: iamportResponse?.imp_uid ?? "", postID: self.postID)), model: PaymentResponse.self)
                    .flatMap { result -> Single<PaymentResponse> in
                        switch result {
                        case .success(let pay):
                            return Single.just(pay)
                        case .failure(let error):
                            print("Error: \(error)")
                            return Single.never()
                        }
                    }
                    .subscribe(onSuccess: { data in
                        print("success: \(data)")
                        NotificationCenter.default.post(name: Notification.Name("paymentCompleted"), object: nil)
                        self.dismiss(animated: true)
                    }, onFailure: { error in
                        print("Error: \(error)")
                        self.dismiss(animated: true)
                    })
                    .disposed(by: disposeBag)
            }
    }
}

