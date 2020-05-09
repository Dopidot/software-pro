import {Column, DataType, Model, Table} from "sequelize-typescript";

@Table
export default class VideoModel extends Model<VideoModel> {

    @Column(DataType.STRING)
    name: String;

    @Column(DataType.STRING)
    path: String;

    constructor(name: String, path: String) {
        super();
        this.name = name;
        this.path = path;
    }
}