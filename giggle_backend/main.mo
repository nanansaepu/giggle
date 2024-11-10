import Nat "mo:base/Nat";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";

// Struktur data
type File = {
    id: Nat;
    owner: Principal;
    name: Text;
    content: Blob;
};

// Variabel dan Fungsi Utama
stable var files : [File] = [];
var fileCount : Nat = 0;

// Fungsi untuk autentikasi dengan Internet Identity
public func isAuthorized(caller: Principal) : Bool {
    return caller == Principal.fromText("<YOUR_PRINCIPAL>"); // Ganti <YOUR_PRINCIPAL> dengan Principal yang sah
}

// Fungsi untuk mengunggah file
public func uploadFile(name: Text, content: Blob) : async ?Nat {
    if (!isAuthorized(msg.caller)) { return null; };
    let file = {
        id = fileCount;
        owner = msg.caller;
        name = name;
        content = content;
    };
    files := files # [file];
    fileCount += 1;
    return ?file.id;
};

// Fungsi untuk mengambil file milik pengguna yang terotentikasi
public query func getUserFiles() : async [File] {
    return files.filter(file -> file.owner == msg.caller);
};

// Fungsi untuk mengambil file berdasarkan ID dengan autentikasi
public query func getFile(fileId: Nat) : async ?File {
    let fileOpt = files.find(file -> file.id == fileId);
    switch (fileOpt) {
        case (?file) if (file.owner == msg.caller) { return ?file; };
        case (_) { return null; };
    };
};

// Fungsi untuk menghapus file berdasarkan ID dengan autentikasi
public func deleteFile(fileId: Nat) : async Bool {
    let index = files.findIndex(file -> file.id == fileId and file.owner == msg.caller);
    switch (index) {
        case (?i) {
            files := files.take(i) # files.drop(i + 1);
            return true;
        };
        case null { return false; };
    };
};
