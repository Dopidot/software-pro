import multer from 'multer';
import { Request } from 'express';
import { extname } from 'path';

/**
 * Author : Guillaume Tako
 * Multer
 */

const storage = multer.diskStorage({
    destination: function (req: Request, file, cb) {
        cb(null, '../uploads/');
    },
    filename: function (req: Request, file: Express.Multer.File, callback: (error: (Error | null), filename: string) => void) {
        callback(null, new Date().getTime() + '-' + file.originalname);
    }
});

/**
 * Function that checks if the file is a picture
 * @param file
 * @param callback
 */
function checkFileType(file: Express.Multer.File, callback: multer.FileFilterCallback) {
    const filetypes = /jpeg|jpg|png|gif/;
    const extensionname = filetypes.test(extname(file.originalname).toLowerCase());
    const mimetype = filetypes.test(file.mimetype);

    if (mimetype && extensionname) {
        return callback(null, true);
    } else {
        return callback(null, false);
    }
}

export const upload = multer({
    storage: storage,
    limits: {
        fileSize: 1024 * 1024 * 10, // 5Mbs
    },
    fileFilter(req: Request, file: Express.Multer.File, callback: multer.FileFilterCallback) {
        checkFileType(file, callback);
    }
});
