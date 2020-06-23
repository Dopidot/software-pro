import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { UserService } from '../services/user.service';

@Component({
    selector: 'ngx-login',
    templateUrl: './login.component.html',
    styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

    constructor(
        private router: Router,
        private userService: UserService,
    ) { }

    ngOnInit(): void {
    }

    login(): void {
        console.log('Here in login function');
        let test = this.userService.login({'email':'christophil@gmail.com', 'password':'azerty123'}).subscribe(data => {
             console.log(data);
          });
        //console.log(test);
        localStorage.setItem('token', '1');
        this.router.navigate(['/home']);
    }
}
