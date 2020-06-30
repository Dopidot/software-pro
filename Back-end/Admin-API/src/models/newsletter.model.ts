export default class NewsletterModel {
    name: string;
    title: string;
    body: string;
    creationDate: Date;
    isSent: boolean;

    constructor(name: string, title: string, body: string, creationDate: Date, isSent: boolean) {
        this.name = name;
        this.title = title;
        this.body = body;
        this.creationDate = creationDate;
        this.isSent = isSent;
    }
}
