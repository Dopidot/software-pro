import ExerciseModel from "./exercise.model";

export default class UserModel {
    firstname: string;
    lastname: string;
    email: string;
    pictureId: number;
    lastConnection: Date;
    exercises: ExerciseModel[];

    constructor(id: number, firstname: string, lastname: string, email: string, pictureId: number, lastConnection: Date, exercises: ExerciseModel[]) {
        this.firstname = firstname;
        this.lastname = lastname;
        this.email = email;
        this.pictureId = pictureId;
        this.lastConnection = lastConnection;
        this.exercises = exercises;
    }
}

