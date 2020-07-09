import {
    HttpEvent,
    HttpInterceptor,
    HttpHandler,
    HttpRequest,
} from '@angular/common/http';
import { Observable } from 'rxjs';

export class HttpHeadersInterceptor implements HttpInterceptor {
    intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
        // Clone the request to add the new header

        let token = localStorage.getItem('token');
        let clonedRequest = req.clone();

        if (token != null) {
            clonedRequest = req.clone({ headers: req.headers.set('Authorization', 'Bearer ' + token) });
        }

        // Pass the cloned request instead of the original request to the next handle
        return next.handle(clonedRequest);
    }
}