export default class NewsletterModel {
    name: string;
    title: string;
    body: string;
    creationDate: Date;
    isSent: boolean;
    newsletterImage: string;

    constructor(name: string, title: string, body: string, creationDate: Date, isSent: boolean, newsletterImage: string) {
        this.name = name;
        this.title = title;
        this.body = body;
        this.creationDate = creationDate;
        this.isSent = isSent;
        this.newsletterImage = newsletterImage;
    }
}
