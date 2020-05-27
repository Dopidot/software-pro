import ProgramModel from "./program.model";
import UserModel from "./user.model";

export default class ExerciseModel{
    name: string;
    description: string;
    repeatNumber: number;
    restTime: string;
    pictureId: number;
    videoId: number;
    programs: ProgramModel[];
    users: UserModel[];

    constructor(name: string, description: string, repeatNumber: number, restTime: string, pictureId: number, videoId: number, programs: ProgramModel[], users: UserModel[]) {
        this.name = name;
        this.description = description;
        this.repeatNumber = repeatNumber;
        this.restTime = restTime;
        this.pictureId = pictureId;
        this.videoId = videoId;
        this.programs = programs;
        this.users = users;
    }
}