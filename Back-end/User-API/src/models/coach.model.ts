/**
 * Author : Guillaume Tako
 * Class : CoachModel
 */

export default class CoachModel {
    id: bigint;
    coachid: string;
    ishighlighted: boolean;

    constructor(id: bigint, coachid: string, ishighlighted: boolean) {
        this.id = id;
        this.coachid = coachid;
        this.ishighlighted = ishighlighted;
    }
}