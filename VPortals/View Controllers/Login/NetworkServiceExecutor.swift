
import Foundation
import DataModel


 
protocol NetworkServiceExecutorProtocol  {
    func authenticateUser(PortalNumber: String, UserName: String, Password: String, successBlock: @escaping () -> Void, failureBlock:@escaping (Error?) ->Void)
}

class NetworkServiceExecutor: NetworkServiceExecutorProtocol {
    var networkService: DataHandlerProtocol
    var keychain: KeychainProtocol
    
    init(networkService: DataHandlerProtocol, keychain: KeychainProtocol) {
        self.networkService = networkService
        self.keychain = keychain
    }
    
    func authenticateUser(PortalNumber: String, UserName: String, Password: String, successBlock: @escaping () -> Void, failureBlock:@escaping (Error?) ->Void) {
        _ = self.networkService.fetchData(parameters: ["PortalNumber":PortalNumber, "UserName":UserName, "Password":Password, "deviceToken":"52.170.151.93"]) { (response: LoginModel?, error: Error?) in
            
            /////// NOTE: ignoring result from API and navigating ahead.
            //print(response);
            //successBlock()
            
            if let error = error {
                failureBlock(error)
            } else if let token = response?.token {
                self.keychain.saveTokenToKeyChain(token: token)
                successBlock()
            }
            
            
        }
    }
}
