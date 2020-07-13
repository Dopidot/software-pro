/**
 * Component : CoachsComponent
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { Component, OnInit, TemplateRef } from '@angular/core';
import { MenuService } from '../services/menu.service';
import { LocalDataSource } from 'ng2-smart-table';
import { NbDialogService } from '@nebular/theme';
import { FitislyService } from '../services/fitisly.service';
import { UserService } from '../services/user.service';
import { DatePipe } from '@angular/common';
import { TranslateService } from '@ngx-translate/core';

@Component({
    selector: 'ngx-coachs',
    templateUrl: './coachs.component.html',
    styleUrls: ['./coachs.component.scss']
})
export class CoachsComponent implements OnInit {

    menu = [];
    data = [];
    coaches = [];
    options: any;
    themeSubscription: any;
    currentUser: any;
    currentCoach: any;
    success = 'success';
    info = 'info';
    danger = 'danger';
    source: LocalDataSource = new LocalDataSource();
    coachNameUserList: string;
    date = new Date();
    titlePseudonym = '';
    titleLastConnection = '';
    settings = {};

    constructor(
        private dialogService: NbDialogService,
        private fitislyService: FitislyService,
        private menuService: MenuService,
        private userService: UserService,
        private datePipe: DatePipe,
        private translate: TranslateService,
    ) { }

    ngOnInit(): void {
        this.menu = this.menuService.getMenu();
        this.loadCoachs();

        this.translate.get('COACH_PSEUDO').subscribe((res: string) => {
            this.titlePseudonym = res;

            this.translate.get('COACH_LAST_CONNECTION').subscribe((res: string) => {
                this.titleLastConnection = res;
                this.initTable();
            });
        });        
    }

    /**
     * Init configuration for table
     */
    initTable(): void {
        this.settings = {
            pager: {
                display: true,
                perPage: 4
            },
            actions: {
                custom: [
                    {
                        name: 'show',
                        title: '<i class="far fa-address-card fa-xs"></i>',
                    },
                ],
                add: false,
                edit: false,
                delete: false,
            },
            columns: {
                pseudo: {
                    title: this.titlePseudonym,
                    type: 'string',
                },
                connection: {
                    title: this.titleLastConnection,
                    valuePrepareFunction: (date) => {
                        return this.datePipe.transform(new Date(date), 'yyyy-MM-dd - HH:mm:ss');
                    }
                },
            },
        };
    }

    /**
     * Load coaches from database
     */
    loadCoachs(): void {
        this.coaches = [];

        this.fitislyService.getCoachs().subscribe(coachs => {
            let coachList = coachs['body']['users'];

            coachList.forEach(oneCoach => {
                this.coaches.push({
                    id: oneCoach['id'],
                    name: oneCoach['pseudonyme'],
                    title: '',
                    picture: this.fitislyService.getPicture(oneCoach['profile_picture']),
                    isHighlighted: false,
                    followers: oneCoach['followers']
                });
            });

            this.loadCoachsHiglighted();
            
        }, error => {
        });
    }

    /**
     * Load highlighted attribut for coaches
     */
    loadCoachsHiglighted(): void {
        this.userService.getCoachHighlighted().subscribe(data => {
            data.forEach(element => {
                let index = this.coaches.findIndex(x => x['id'].toString() === element['coachid']);

                if (index !== -1) {
                    this.coaches[index]['isHighlighted'] = true;
                    this.coaches[index]['idHighlight'] = element['id'];
                }
            });
        });
    }

    /**
     * Load users from a specific coach
     */
    loadUsers(coach): void {
        this.currentCoach = coach;
        this.coachNameUserList = coach['name'];
        this.data = [];
        let index = 0;

        this.currentCoach['followers'].forEach(user => {
            this.fitislyService.getUserInfo(user['account_id']).subscribe(info => {
                let userInfo = info['body']['user_profile'];
    
                this.data.push({
                    pseudo: userInfo['pseudonyme'],
                    lastName: this.capitalize(userInfo['last_name']),
                    firstName: this.capitalize(userInfo['first_name']),
                    email: userInfo['mail'],
                    connection: userInfo['last_connection_date'],
                    picture: this.fitislyService.getPicture(userInfo['profile_picture'])
                });

                index++;

                if (index % 8 === 0 || this.currentCoach['followers'].length === index)
                {
                    this.source.load(this.data);
                }

            }, error => {
            });    
        });
    } 

    /**
     * Open popup with user informations
     */
    openUnfollow(event, dialog: TemplateRef<any>): void {
        this.currentUser = event.data;

        this.dialogService.open(
            dialog
        );
    }

    /**
     * Open popup to update coach attribut
     */
    openEditCoach(coach, dialog: TemplateRef<any>): void {
        this.currentCoach = coach;

        this.dialogService.open(
            dialog
        );
    }

    /**
     * Update (insert or delete) highlighted attribut for a specific coach
     */
    updatehighlightCoach(toHighlight: boolean): void {
        if (toHighlight)
        {
            this.userService.createCoachHighlighted(this.currentCoach['id']).subscribe(data => {
                this.currentCoach.isHighlighted = true;
                let index = this.coaches.findIndex(x => x['id'] === this.currentCoach['id']);

                if (index !== -1) {
                    this.coaches[index]['isHighlighted'] = true;
                    this.coaches[index]['idHighlight'] = data['body']['coach']['id'];
                }
            });
        }
        else
        {
            this.userService.deleteCoachHighlighted(this.currentCoach['idHighlight']).subscribe(data => {
                this.currentCoach.isHighlighted = false;
                let index = this.coaches.findIndex(x => x['id'] === this.currentCoach['id']);

                if (index !== -1) {
                    this.coaches[index]['isHighlighted'] = false;
                }
            });
        }
    }

    /**
     * Capitalize the first letter for a string
     * @input s : string
     * @output string
     */
    capitalize(s: string): string {
        return s.charAt(0).toUpperCase() + s.slice(1);
    }

}
