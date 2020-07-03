import multer from "multer";
import {Request} from "express";

let storage = multer.diskStorage({
    destination: function (req: Request, file, cb) {
        cb(null, './uploads/');
    },
    filename: function (req: Request, file: Express.Multer.File, callback: (error: (Error | null), filename: string) => void) {
        callback(null, new Date().toISOString() + '-' + file.originalname);
    }
});

export let upload = multer({
    storage: storage,
    limits: {
        fileSize: 1024 * 1024 * 5, // 5Mbs
    },
    fileFilter(req: Request, file: Express.Multer.File, callback: multer.FileFilterCallback) {
        if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/png') {
            callback(null, true);
        } else {
            callback(null, false);
        }
    }
});
