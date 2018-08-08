import Foundation

public class Storage {

    public func saveAuthenticationData(data: IbmQX_UserLogin) -> Bool {
        if let encodedUserLogin = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encodedUserLogin, forKey: "auth.data")
            return true
        }
        return false
    }

    public func loadAuthenticationData() -> IbmQX_UserLogin? {
        if let encodedUserLogin = UserDefaults.standard.data(forKey: "auth.data"),
            let decodedUserLogin = try? JSONDecoder().decode(IbmQX_UserLogin.self, from: encodedUserLogin) {
            return decodedUserLogin
        }
        return nil
    }

}
