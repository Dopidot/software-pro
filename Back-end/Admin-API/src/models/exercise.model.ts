import {Column, DataType, Model, Table} from "sequelize-typescript";
import PictureModel from "./picture.model";
import UserModel from "./user.model";
import ProgramModel from "./program.model";

@Table
export default class ExerciseModel extends Model<ExerciseModel> {

    @Column(DataType.STRING)
    name: String;

    @Column(DataType.STRING)
    description: String;

    @Column(DataType.SMALLINT)
    repeatNumber: Number;

    @Column(DataType.STRING)
    restTime: String;

    picture: PictureModel;

    programs: ProgramModel[];

    users: UserModel[];

    constructor(name: String, description: String, repeatNumber: Number, restTime: String, picture: PictureModel, programs: ProgramModel[], users: UserModel[]) {
        super();
        this.name = name;
        this.description = description;
        this.repeatNumber = repeatNumber;
        this.restTime = restTime;
        this.picture = picture;
        this.programs = programs;
        this.users = users;
    }
}