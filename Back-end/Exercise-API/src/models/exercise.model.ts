//import UserModel from "./user.model";

export default class ExerciseModel{
    name: string;
    description: string;
    repeatNumber: number;
    restTime: string;
    exerciseImage: string;
    //users: UserModel[];

    constructor(name: string, description: string, repeatNumber: number, restTime: string, exerciseImage: string) {//, programs: ProgramModel[], users: UserModel[]) {
        this.name = name;
        this.description = description;
        this.repeatNumber = repeatNumber;
        this.restTime = restTime;
        this.exerciseImage = exerciseImage;
        //this.users = users;
    }
}