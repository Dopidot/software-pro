/**
 * author : Guillaume Tako
 */

export default class NewsletterModel {
    id: bigint;
    name: string;
    title: string;
    body: string;
    creationdate: Date;
    issent: boolean;
    newsletterimage: string;

    constructor(id: bigint, name: string, title: string, body: string, creationdate: Date, issent: boolean, newsletterimage: string) {
        this.id = id;
        this.name = name;
        this.title = title;
        this.body = body;
        this.creationdate = creationdate;
        this.issent = issent;
        this.newsletterimage = newsletterimage;
    }
}
