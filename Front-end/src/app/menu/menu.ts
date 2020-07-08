import { NbMenuItem } from '@nebular/theme';

export const MENU_ITEMS: NbMenuItem[] = [
    {
        title: 'Accueil',
        icon: 'home-outline',
        link: '/home',
        home: true,
    },
    {
        title: 'Membres',
        icon: 'people-outline',
        link: '/members'
    },
    {
        title: 'Coaching',
        icon: 'trending-up-outline',
        children: [
            {
                title: 'Coachs',
                link: '/coachs'
            },
            {
                title: 'Programmes',
                link: '/programs'
            },
            {
                title: 'Exercices',
                link: '/exercises'
            }
        ],
    },
    {
        title: 'Communauté',
        icon: 'message-square-outline',
        children: [
            {
                title: 'Actualités de la salle',
                link: '/news'
            },
            {
                title: 'Notifications',
                link: '/notifications'
            }
        ],
    },
    {
        title: 'Evènements',
        icon: 'calendar-outline',
        link: '/events'
    },
    {
        title: 'Informations',
        icon: 'info-outline',
        link: '/infos'
    }
];

