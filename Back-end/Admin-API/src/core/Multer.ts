import multer from "multer";
import {Request} from "express";
import * as path from "path";

let storage = multer.diskStorage({
    destination: function (req: Request, file, cb) {
        cb(null, './uploads/');
    },
    filename: function (req: Request, file: Express.Multer.File, callback: (error: (Error | null), filename: string) => void) {
        callback(null, new Date().toISOString() + '-' + file.originalname);
    }
});

function checkFileType(file: Express.Multer.File, callback: multer.FileFilterCallback) {
    const filetypes = /jpeg|jpg|png/;
    const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = filetypes.test(file.mimetype);

    if (mimetype && extname) {
        return callback(null, true);
    } else {
        return callback(null, false);
    }
}

export let upload = multer({
    storage: storage,
    limits: {
        fileSize: 1024 * 1024 * 5, // 5Mbs
    },
    fileFilter(req: Request, file: Express.Multer.File, callback: multer.FileFilterCallback) {
        checkFileType(file, callback);
    }
});
