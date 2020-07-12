/**
 * Component : LoginComponent
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { UserService } from '../services/user.service';
import { User } from '../models/user.model';
import { TranslateService } from '@ngx-translate/core';

@Component({
    selector: 'ngx-login',
    templateUrl: './login.component.html',
    styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

    user: User = new User();
    errorMessage: string;

    constructor(
        private router: Router,
        private userService: UserService,
        public translate: TranslateService,
    ) {
        translate.addLangs(['en', 'fr']);
        this.loadLanguage();
    }

    ngOnInit(): void {
    }

    loadLanguage(): void {
        let lang = localStorage.getItem('language');

        if (lang != null) {
            this.translate.use(lang);
        }
        else {
            localStorage.setItem('language', 'fr');
            this.translate.use('fr');
        }
    }

    login(): void {
        this.errorMessage = null;

        this.userService.connectUser(this.user).subscribe(data => {
            localStorage.setItem('token', data['accessToken']);
            console.log(data);
            localStorage.setItem('userInfo', JSON.stringify(data['user']));

            this.router.navigate(['/home']);
        }, error => {
            
            this.translate.get('LOGIN_INVALID').subscribe((res: string) => {
                this.errorMessage = res;
            });
        });
    }

    setLanguage(num: number): void {
        let language = num === 1 ? 'fr' : 'en';

        localStorage.setItem('language', language);
        window.location.reload();
    }
}
