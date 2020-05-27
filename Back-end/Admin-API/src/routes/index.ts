import { Router } from 'express'
const router = Router();

import { getUsers, getUserById, createUser, deleteUser, updateUser } from '../controllers/index.controller';

// TODO nom de l'api dans le futur 'admin_api/exercises/'
// TODO nom de l'api dans le futur 'admin_api/programs/'
// TODO nom de l'api dans le futur 'admin_api/users/'


// USERS
router.get('/users', getUsers); //200
router.get('/users/:id', getUserById); // 200
router.post('/users', createUser); // 201
router.put('/users/:id', deleteUser); //200 ou 201
router.delete('/users/:id', updateUser); // 200

//EXERCISES
router.get('/exercises', );
router.get('/exercises/:id', );
router.post('/exercises', );
router.put('/exercises/:id', );
router.delete('/exercises/:id', );

//PROGRAMS
router.get('/programs', );
router.get('/programs/:id', );
router.post('/programs', );
router.put('/programs/:id', );
router.delete('/programs/:id', );

//PICTURES
router.get('/pictures', );
router.get('/pictures/:id', );
router.post('/pictures', );
router.put('/pictures/:id', );
router.delete('/pictures/:id', );

//VIDEOS
router.get('/videos', );
router.get('/videos/:id', );
router.post('/videos', );
router.put('/videos/:id', );
router.delete('/videos/:id', );

export default router;
