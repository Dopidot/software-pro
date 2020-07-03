export default class UserModel {
    firstname: string;
    lastname: string;
    email: string;
    password: string;
    userImage: string;
    lastConnection: Date;
    //exercises: ExerciseModel[];

    constructor(id: number, firstname: string, lastname: string, email: string, password: string, userImage: string, lastConnection: Date) {//, exercises: ExerciseModel[]) {
        this.firstname = firstname;
        this.lastname = lastname;
        this.email = email;
        this.password = password;
        this.userImage = userImage;
        this.lastConnection = lastConnection;
        //this.exercises = exercises;
    }
}

