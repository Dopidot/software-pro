//import ExerciseModel from "./exercise.model";

export default class UserModel {
    firstname: string;
    lastname: string;
    email: string;
    password: string;
    pictureId: number;
    lastConnection: Date;
    //exercises: ExerciseModel[];

    constructor(id: number, firstname: string, lastname: string, email: string, password: string, pictureId: number, lastConnection: Date) {//, exercises: ExerciseModel[]) {
        this.firstname = firstname;
        this.lastname = lastname;
        this.email = email;
        this.password = password;
        this.pictureId = pictureId;
        this.lastConnection = lastConnection;
        //this.exercises = exercises;
    }
}
