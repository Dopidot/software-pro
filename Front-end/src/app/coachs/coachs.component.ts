import { Component, OnInit, TemplateRef } from '@angular/core';
import { MENU_ITEMS } from '../menu/menu';
import { NbThemeService, NbColorHelper } from '@nebular/theme';

import { LocalDataSource } from 'ng2-smart-table';
import { SmartTableData } from '../@core/data/smart-table';
import { NbDialogService } from '@nebular/theme';

@Component({
    selector: 'ngx-coachs',
    templateUrl: './coachs.component.html',
    styleUrls: ['./coachs.component.scss']
})
export class CoachsComponent implements OnInit {

    menu = MENU_ITEMS;
    data: any;
    options: any;
    themeSubscription: any;
    currentUser: any;
    currentCoach: any;
    success = 'success';
    info = 'info';
    danger = 'danger';
    source: LocalDataSource = new LocalDataSource();

    settings = {
        pager: {
            display: true,
            perPage: 4
        },
        actions: {
            add: false,
            edit: false,
        },
        delete: {
            deleteButtonContent: '<i class="nb-trash"></i>',
            confirmDelete: true,
        },
        columns: {
            pseudo: {
                title: 'Pseudonyme',
                type: 'string',
            },
            connection: {
                title: 'Dernière connexion',
                type: 'string',
            },
        },
    };

    coaches: { name: string, title: string, picture: string, isHighlighted: boolean }[] = [
        { name: 'Carla Espinosa', title: 'Renforcement musculaire', picture: 'assets/images/eva.png', isHighlighted: true },
        { name: 'Bob Kelso', title: 'Bras', picture: 'assets/images/alan.png', isHighlighted: false },
        { name: 'Janitor', title: 'Cardio', picture: 'assets/images/nick.png', isHighlighted: true },
        { name: 'Perry Cox', title: 'Sans équipement', picture: 'assets/images/lee.png', isHighlighted: false },
        { name: 'Ben Sullivan', title: 'Apprentissage pour débutant', picture: 'assets/images/jack.png', isHighlighted: false },
    ];

    date = new Date();

    constructor(
        private theme: NbThemeService,
        private service: SmartTableData,
        private dialogService: NbDialogService,
    ) {
        this.themeSubscription = this.theme.getJsTheme().subscribe(config => {

            const colors: any = config.variables;
            const chartjs: any = config.variables.chartjs;

            this.data = {
                labels: ['2006', '2007', '2008', '2009', '2010', '2011', '2012'],
                datasets: [{
                    data: [65, 59, 80, 81, 56, 55, 40],
                    label: 'Series A',
                    backgroundColor: NbColorHelper.hexToRgbA(colors.primaryLight, 0.8),
                }, {
                    data: [28, 48, 40, 19, 86, 27, 90],
                    label: 'Series B',
                    backgroundColor: NbColorHelper.hexToRgbA(colors.infoLight, 0.8),
                }],
            };

            this.options = {
                maintainAspectRatio: false,
                responsive: true,
                legend: {
                    labels: {
                        fontColor: chartjs.textColor,
                    },
                },
                scales: {
                    xAxes: [
                        {
                            gridLines: {
                                display: false,
                                color: chartjs.axisLineColor,
                            },
                            ticks: {
                                fontColor: chartjs.textColor,
                            },
                        },
                    ],
                    yAxes: [
                        {
                            gridLines: {
                                display: true,
                                color: chartjs.axisLineColor,
                            },
                            ticks: {
                                fontColor: chartjs.textColor,
                            },
                        },
                    ],
                },
            };
        });

    }

    ngOnInit(): void {
    }

    ngOnDestroy(): void {
        this.themeSubscription.unsubscribe();
    }

    loadUsers(coach): void {
        this.currentCoach = coach;

        this.data = [
            {
                pseudo: 'Christophil',
                lastName: 'Philemon',
                firstName: 'Christopher',
                email: 'chris.philemon@gmail.com',
                connection: '06:50 le 02/06/2020',
                picture: 'assets/images/alan.png'
            },
            {
                pseudo: 'Juanito',
                lastName: 'Deyehe',
                firstName: 'Jean',
                email: 'jean.deyehe@gmail.com',
                connection: '18:30 le 28/05/2020',
                picture: 'assets/images/jack.png'
            },
            {
                pseudo: 'Bigyeezy',
                lastName: 'Tako',
                firstName: 'Guillaume',
                email: 'guillaume.tako@hotmail.fr',
                connection: '22:51 le 25/05/2020',
                picture: 'assets/images/nick.png'
            },
            {
                pseudo: 'Bigyeezy',
                lastName: 'Tako',
                firstName: 'Guillaume',
                email: 'guillaume.tako@hotmail.fr',
                connection: '22:51 le 25/05/2020',
                picture: 'assets/images/nick.png'
            },
            {
                pseudo: 'Bigyeezy',
                lastName: 'Tako',
                firstName: 'Guillaume',
                email: 'guillaume.tako@hotmail.fr',
                connection: '22:51 le 25/05/2020',
                picture: 'assets/images/nick.png'
            },
        ];

        this.source.load(this.data);
    } 

    openPopup(event, dialog: TemplateRef<any>): void {
        this.currentUser = event.data;

        this.dialogService.open(
            dialog
        );
    }

    openEditCoach(coach, dialog: TemplateRef<any>): void {
        this.currentCoach = coach;
        console.log(coach);

        this.dialogService.open(
            dialog
        );
    }

    confirmDelete(): void {
        console.log('Unfollow success !');
    }

}
