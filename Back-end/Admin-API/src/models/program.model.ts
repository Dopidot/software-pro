import {Table, Model, Column, DataType} from "sequelize-typescript";
import PictureModel from "./picture.model";
import ExerciseModel from "./exercise.model";

@Table
export default class ProgramModel extends Model<ProgramModel> {

    @Column(DataType.STRING)
    name: String;

    @Column(DataType.STRING)
    description: String;

    picture: PictureModel;

    exercises: ExerciseModel[];

    constructor(name: String, description: String, picture: PictureModel, exercises: ExerciseModel[]) {
        super();
        this.name = name;
        this.description = description;
        this.picture = picture;
        this.exercises = exercises;
    }
}