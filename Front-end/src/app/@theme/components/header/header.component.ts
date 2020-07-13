import { Component, OnDestroy, OnInit } from '@angular/core';
import { NbMediaBreakpointsService, NbMenuService, NbSidebarService, NbThemeService } from '@nebular/theme';

import { UserData } from '../../../@core/data/users';
import { LayoutService } from '../../../@core/utils';
import { map, takeUntil } from 'rxjs/operators';
import { Subject } from 'rxjs';
import { Router } from '@angular/router';
import { TranslateService } from '@ngx-translate/core';
import { CommonService } from '../../../services/common.service';

@Component({
    selector: 'ngx-header',
    styleUrls: ['./header.component.scss'],
    templateUrl: './header.component.html',
})
export class HeaderComponent implements OnInit, OnDestroy {

    private destroy$: Subject<void> = new Subject<void>();
    userPictureOnly: boolean = false;
    user: any;

    themes = [
        {
            value: 'default',
            name: 'Light',
        },
        {
            value: 'dark',
            name: 'Dark',
        },
        {
            value: 'cosmic',
            name: 'Cosmic',
        },
        {
            value: 'corporate',
            name: 'Corporate',
        },
    ];

    currentTheme = 'default';

    userMenu = [ /*{ title: 'Profile' },*/ { title: '', action: 1 }];

    constructor(private sidebarService: NbSidebarService,
        private menuService: NbMenuService,
        private themeService: NbThemeService,
        private userService: UserData,
        private layoutService: LayoutService,
        private breakpointService: NbMediaBreakpointsService,
        private router: Router,
        private translate: TranslateService,
        private commonService: CommonService,
    ) {
        translate.addLangs(['en', 'fr']);
        this.loadLanguage();
    }

    ngOnInit() {
        this.currentTheme = this.themeService.currentTheme;

        let userInfo = localStorage.getItem('userInfo');

        if (userInfo == null) {
            this.logout();
            return;
        }

        userInfo = JSON.parse(userInfo);

        this.user = {
            'name': userInfo['firstname'] + ' ' + userInfo['lastname'],
            'picture': userInfo['userimage'] ? this.commonService.getPicture(userInfo['userimage']) : ''
        };

        /*this.userService.getUsers()
          .pipe(takeUntil(this.destroy$))
          .subscribe((users: any) => this.user = users.nick);*/

        const { xl } = this.breakpointService.getBreakpointsMap();
        this.themeService.onMediaQueryChange()
            .pipe(
                map(([, currentBreakpoint]) => currentBreakpoint.width < xl),
                takeUntil(this.destroy$),
            )
            .subscribe((isLessThanXl: boolean) => this.userPictureOnly = isLessThanXl);

        this.themeService.onThemeChange()
            .pipe(
                map(({ name }) => name),
                takeUntil(this.destroy$),
            )
            .subscribe(themeName => this.currentTheme = themeName);

        this.menuService.onItemClick().subscribe((event) => {
            if (event.item['action'] === 1) {
                this.logout();
            }
        });
    }

    ngOnDestroy() {
        this.destroy$.next();
        this.destroy$.complete();
    }

    changeTheme(themeName: string) {
        this.themeService.changeTheme(themeName);
    }

    toggleSidebar(): boolean {
        this.sidebarService.toggle(true, 'menu-sidebar');
        this.layoutService.changeLayoutSize();

        return false;
    }

    navigateHome() {
        this.menuService.navigateHome();
        return false;
    }

    logout(): void {
        localStorage.removeItem('token');
        localStorage.removeItem('userInfo');

        this.router.navigate(['/login']);
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

        this.translate.get('NAVBAR_LOGOUT').subscribe((res: string) => {
            this.userMenu[0] = {
                title: res,
                action: 1
            };
        });
    }

    setLanguage(num: number): void {
        let language = num === 1 ? 'fr' : 'en';

        localStorage.setItem('language', language);
        window.location.reload();
    }
}
