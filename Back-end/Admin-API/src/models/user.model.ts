/**
 * author : Guillaume Tako
 */

export class UserModel {
    id: bigint;
    firstname: string;
    lastname: string;
    email: string;
    lastconnection: Date;
    userimage: string;


    constructor(id: bigint, firstname: string, lastname: string, email: string, lastConnection: Date, userImage: string) {
        this.id = id;
        this.firstname = firstname;
        this.lastname = lastname;
        this.email = email;
        this.lastconnection = lastConnection;
        this.userimage = userImage;
    }
}

export class UserLoginModel {
    id: bigint;
    firstname: string;
    lastname: string;
    email: string;
    password: string;
    lastconnection: Date;
    userimage: string;


    constructor(id: bigint, firstname: string, lastname: string, email: string, password: string, lastConnection: Date, userImage: string) {
        this.id = id;
        this.firstname = firstname;
        this.lastname = lastname;
        this.email = email;
        this.password = password;
        this.lastconnection = lastConnection;
        this.userimage = userImage;
    }
}
