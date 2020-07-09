import { Program } from './program.model';
import { User } from './user.model';

export class Exercise {
    public id: number;
    public name: string;
    public description: string;
    public repeatNumber: number;
    public restTime: number;
    public pictureId: number;
    public videoId: number;
    public programs: Program[];
    public users: User[];

    constructor() {}
}