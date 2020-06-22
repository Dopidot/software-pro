import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
    selector: 'ngx-login',
    templateUrl: './login.component.html',
    styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

    constructor(
        private router: Router,
    ) { }

    ngOnInit(): void {
    }

    login(): void {
        localStorage.setItem('token', '1');
        this.router.navigate(['/home']);
    }
}
