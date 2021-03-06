//
//  ApiProvider.swift
//  VIPPER
//
//  Created by Manh Pham on 3/16/21.
//

final class ApiProvider<Target: TargetType>: MoyaProvider<Target>, HasDisposeBag {
    
    init(plugins: [PluginType]) {
        super.init(plugins: plugins)
    }
    
    func request(target: Target) -> Observable<Response> {
        return connectedToInternet()
            .take(1)
            .flatMapLatest({ _ -> Observable<Response> in
                return self
                    .rx
                    .request(target)
                    .filterSuccessfulStatusCodes()
                    .do(onError: { [weak self] error in
                        guard let self = self else { return }
                        self.handleError(error: error, target: target)
                    })
                    .asObservable()
                    .catchError { [weak self] (error) -> Observable<Response> in
                        guard let self = self else { return .empty() }
                        return self.handleRetry(error: error, target: target)
                    }
            })
    }
    
    private func handleError(error: Error, target: Target) {
        if let error = error as? MoyaError {
            switch error {
            case .statusCode(let response):
                guard let target = (target as? MultiTarget)?.target as? ApiRouter else { return }
                guard target.needShowDialogWhenBadStatuCode else { return }
                if ErrorCode(rawValue: response.statusCode)?.isError ?? false {
                    AppHelper.shared.showAlert(title: "An error occurred", message: "Unknown error").subscribe() ~ disposeBag
                }
            default:
                break
            }
        }
    }
    
    private func handleRetry(error: Error, target: Target) -> Observable<Response> {
        guard let _target = (target as? MultiTarget)?.target as? ApiRouter else { return .empty() }
        guard _target.canRetryRequest else { return .empty() }
        if let error = error as? MoyaError {
            switch error {
            case .underlying(let error, _):
                if let error = error as? AFError {
                    switch error {
                    case .sessionTaskFailed:
                        return AppHelper
                            .shared
                            .showAlertConfirm(title: "Cannot connect to server",
                                              message: "Please check the connection and try again",
                                              ok: "Reload")
                            .flatMap { [weak self] in
                                self?.request(target: target) ?? .empty()
                            }
                    default:
                        break
                    }
                }
            default:
                break
            }
        }
        return .empty()
    }
}
