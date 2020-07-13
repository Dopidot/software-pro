export function removeLastDirectoryFromCWDPath(path: string): string {
    const array: string[] = path.split('/');
    console.log(array);
    array.pop();
    return array.join('/');
}