import { Component } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';

@Component({
    selector: 'ngx-footer',
    styleUrls: ['./footer.component.scss'],
    templateUrl: './footer.component.html',
})
export class FooterComponent {

    footer: string;

    constructor(
        public translate: TranslateService,
    ) {
        translate.addLangs(['en', 'fr']);
        
        let lang = localStorage.getItem('language');

        if (lang != null)
        {
            this.translate.use(lang);
        }
        else
        {
            localStorage.setItem('language', 'fr');
            this.translate.use('fr');
        }
    }

    ngOnInit() {
        this.translate.get('FOOTER_RIGHTS').subscribe((res: string) => {
            this.footer = res;
        });
    }
    
}
