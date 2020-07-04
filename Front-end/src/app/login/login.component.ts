import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { UserService } from '../services/user.service';
import { User } from '../models/user.model';

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
    ) { }

    ngOnInit(): void {
    }

    login(): void {
        this.errorMessage = null;

        this.userService.connectUser(this.user).subscribe(data => {
            localStorage.setItem('token', data['accessToken']);
            localStorage.setItem('userInfo', JSON.stringify(data['user']));

            this.router.navigate(['/home']);
        }, error => {
            this.errorMessage = 'Adresse email ou mot de passe incorrect.';
        });
    }

    setLanguage(num: number): void {
        let language = num === 1 ? 'fr' : 'en';
        localStorage.setItem('language', language);
    }
}
