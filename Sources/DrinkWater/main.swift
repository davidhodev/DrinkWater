import Alamofire
import Foundation

if let accountSID = ProcessInfo.processInfo.environment["AC72ce0e1e8873389e9467edfd9eabd86e"],
    let authToken = ProcessInfo.processInfo.environment["515e1ee53415c2619f8f2290c92d9ba8"] {
    
    let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
    let parameters = ["From": "+12133194018", "To": "+1 213-605-5210", "Body": "Drink Water Slut test!"]
    
    Alamofire.request(url, method: .post, parameters: parameters)
        .authenticate(user: accountSID, password: authToken)
        .responseJSON { response in
            debugPrint(response)
            print(response)
    }
}
