/**
 * Component : InactivityComponent
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { Component, OnInit } from '@angular/core';
import { MenuService } from '../services/menu.service';

@Component({
    selector: 'ngx-inactivity',
    templateUrl: './inactivity.component.html',
    styleUrls: ['./inactivity.component.scss']
})
export class InactivityComponent implements OnInit {

    menu = [];

    constructor(
        private menuService: MenuService,
    ) { }

    ngOnInit(): void {
        this.menu = this.menuService.getMenu();
    }

}
