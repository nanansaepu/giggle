import Principal "mo:base/Principal";

actor AuthModule {
    stable var authorizedUsers : [Principal] = [];

    public func addAuthorizedUser(user: Principal) : async Bool {
        if (!authorizedUsers.contains(user)) {
            authorizedUsers := authorizedUsers # [user];
            return true;
        };
        return false;
    };

    public func removeAuthorizedUser(user: Principal) : async Bool {
        let index = authorizedUsers.findIndex(existingUser -> existingUser == user);
        switch (index) {
            case (?i) {
                authorizedUsers := authorizedUsers.take(i) # authorizedUsers.drop(i + 1);
                return true;
            };
            case null { return false; };
        };
    };

    public query func isUserAuthorized(user: Principal) : async Bool {
        return authorizedUsers.contains(user);
    };
};
