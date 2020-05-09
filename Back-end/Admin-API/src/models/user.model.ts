import {Table, Column, Model, AllowNull, NotEmpty, DataType} from "sequelize-typescript";
import ExerciseModel from "./exercise.model";
import PictureModel from "./picture.model";

@Table
export default class UserModel extends Model{

    @AllowNull(false)
    @NotEmpty
    @Column(DataType.STRING)
    firstname: String;

    @AllowNull(false)
    @NotEmpty
    @Column(DataType.STRING)
    lastname: String;

    @AllowNull(false)
    @NotEmpty
    @Column(DataType.STRING)
    email: String;

    @Column(DataType.BLOB)
    picture: PictureModel;

    @Column(DataType.DATE)
    lastConnection: Date;

    exercises: ExerciseModel[];

    constructor(id: Number, firstname: String, lastname: String, email: String, picture: PictureModel, lastConnection: Date, exercises: ExerciseModel[]) {
        super();
        this.firstname = firstname;
        this.lastname = lastname;
        this.email = email;
        this.picture = picture;
        this.lastConnection = lastConnection;
        this.exercises = exercises;
    }
}

