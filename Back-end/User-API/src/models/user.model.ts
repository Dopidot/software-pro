/**
 * author : Guillaume Tako
 */

export class UserModel {
    id: bigint;
    firstname: string;
    lastname: string;
    email: string;
    password: string;
    lastconnection: Date;
    userimage: string;

    constructor(id: bigint, firstname: string, lastname: string, email: string, password: string, lastconnection: Date, userimage: string) {
        this.id = id;
        this.firstname = firstname;
        this.lastname = lastname;
        this.email = email;
        this.password = password;
        this.lastconnection = lastconnection;
        this.userimage = userimage;
    }
}
