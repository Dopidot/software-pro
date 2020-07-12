/**
 * Class : DynamicLocaleId
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

export class DynamicLocaleId extends String {
    locale: string;
  
    toString() {
      return this.locale;
    }
  }